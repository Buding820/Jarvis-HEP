#!/usr/bin/env python3

import configparser
from copy import deepcopy
import json
import os
from subprocess import Popen, run
import sys
import time 
from program import Pack
import argparse
from config import ConfigLoader
from logger import AppLogger
import logging
from base import Base
from distributor import Distributor
import dill 
from threading import Timer
from library import Library
from workflow import Workflow
from factory import WorkerFactory 
from sample import Sample
from moduleManager import ModuleManager
from pprint import pprint


class Core(Base):
    def __init__(self, logger) -> None:
        # print("Testing the first logging line")
        super().__init__()
        self.argparser: Any             = None
        self.info: Dict[str, Any]       = {}
        self.yaml: ConfigLoader         = ConfigLoader()
        self.sampler: Any               = None
        self.libraries: Any             = None
        self.factory: Any               = None 
        self.likelihood: Any            = None 
        self.logger: AppLogger          = None
        self.__state_saver              = None
        self.module_manager             = None

    def init_argparser(self) -> None:
        self.argparser = argparse.ArgumentParser(description="Jarvis Program Help Center")
        self.info['args'] = load_args_config(self.path['args_info'])
        
        for pos_arg in self.info['args'].get('positionals', []):
            self.argparser.add_argument(pos_arg['name'], help=pos_arg['help'])
        for opt in self.info['args'].get('options', []):
            kwargs = {
                'help': opt['help'],
                'action': opt.get('action', 'store'),
                'dest': opt.get('dest')
            }
            if 'default' in opt:
                kwargs['default'] = opt['default']
            if "type" in opt:
                if opt['type'] == 'int':
                    kwargs['type'] = int
                elif opt['type'] == 'float':
                    kwargs['type'] = float
                else:
                    kwargs['type'] = str
            if 'short' in opt and 'long' in opt:
                self.argparser.add_argument(
                    opt['short'],
                    opt['long'],
                    **kwargs
                )
            elif 'long' in opt:
                self.argparser.add_argument(
                    opt['long'], **kwargs
                )
        self.check_init_args()

    def init_project(self) -> None: 
        self.info['scan_name'] = self.yaml.config['Scan']['name']
        task_result_dir = os.path.join(self.yaml.config['Scan']['save_dir'], self.info['scan_name'])
        task_result_dir = self.decode_path(task_result_dir)
        self.info['sample'] = {
            "task_result_dir": self.decode_path(task_result_dir),
            "sample_dirs": os.path.join(task_result_dir, "SAMPLE"),
            "jarvis_log":  os.path.abspath(f"{self.info['project_name']}.log")
        }
        if not os.path.exists(task_result_dir):
            os.makedirs(task_result_dir)
            os.makedirs(os.path.join(task_result_dir, "SAMPLE"))
        # pprint(self.yaml.config)

    def init_logger(self) -> None:
        self.info["project_name"] = os.path.splitext(os.path.basename(self.args.file))[0]
        self.logger = AppLogger(
            config_path=self.path['logger_config_path'],
            logger_name="Jarvis-HEP",
            log_file_name=f"{self.info['project_name']}.log"
        )
        self.logger.info['debug_mode'] = self.args.debug
        self.logger.configure_logging()
        self.logger.print_logo()
        self.logger.logger.info("Jarvis-HEP logging system initialized successful!")
        if self.args.debug:
            self.logger.logger.info("Jarvis-HEP in debug mode currently!")
        
        # child_logger = self.logger.create_dynamic_logger("Test_Child_Logger", log_file="child.log")
        # self.logger.delete_child_logger("Test_Child_Logger", child_logger)

    def init_configparser(self) -> None: 
        self.yaml.logger = self.logger.create_dynamic_logger("ConfigParser")
        from copy import deepcopy
        self.yaml.path = deepcopy(self.path)
        self.yaml.load_config(os.path.abspath(self.args.file))
        self.yaml.check_dependency_installed()
        self.sampler = Distributor.set_method(self.yaml.get_sampling_method()) 
        self.yaml.set_schema(self.sampler.schema)
        self.yaml.validate_config()

    def init_StateSaver(self) -> None:
        logger = self.logger.create_dynamic_logger("StateSaver", logging.INFO)
        logger.warning("Enabling breakpoint resume function ... ")
        filename = f"{self.info['project_name']}.pkl"
        self.__state_saver = self.__StateSaver(self, filename=filename, logger=logger, save_interval_seconds=60)

    def init_sampler(self) -> None:
        self.sampler.set_config(self.yaml.config)
        logger = self.logger.create_dynamic_logger(self.sampler.method)
        self.sampler.set_logger(logger)
        self.sampler.initialize()
        self.yaml.vars = self.sampler.vars 

    def init_librarys(self) -> None:
        self.libraries = Library()
        self.libraries._skip_library = self.args.skiplibrary
        logger = self.logger.create_dynamic_logger("Library", logging.INFO)
        self.libraries.set_logger(logger)
        self.libraries.set_config(self.yaml.config)
        for module in self.libraries.modules:
            mod = self.libraries.modules[module]
            log_file = mod.path['log_file_path']
            logger = self.logger.create_dynamic_logger(mod.name, logging.WARNING, log_file=log_file)
            mod.set_logger(logger)
        self.libraries.display_installation_summary()
        for module in self.libraries.modules.values():
            module.install()

    def init_workflow(self) -> None: 
        self.workflow = Workflow()
        modules = self.yaml.get_modules()
        self.workflow.set_modules(modules)
        self.workflow.resolve_dependencies()
        if not self.args.skipFC:
            self.workflow.draw_flowchart()
        self.workflow.get_workflow_dict()

    def init_WorkerFactory(self) -> None: 
        self.factory = WorkerFactory()
        self.module_manager = ModuleManager()
        self.factory.configure(module_manager=self.module_manager,
            max_workers=self.yaml.config['Calculators']['make_paraller']
            )
        logger = self.logger.create_dynamic_logger("Manager")
        self.factory.set_logger(logger)
        self.module_manager.set_logger(logger)
        self.module_manager.set_max_worker(self.yaml.config['Calculators']['make_paraller'])
        self.module_manager.set_config(self.yaml.config)
        self.module_manager.workflow = deepcopy(self.workflow.workflow)
        for kk, layer in self.workflow.calc_layer.items():
            if kk > 1: 
                for module in layer['module']:
                    logger = self.logger.create_dynamic_logger(module)
                    self.module_manager.add_module_pool(self.workflow.modules[module], logger=logger)

    def initialization(self) -> None:
        self.init_argparser()
        self.init_logger()
        self.init_configparser()
        self.init_StateSaver()
        self.init_sampler()
        self.init_workflow()
        self.init_librarys()
        self.init_WorkerFactory()
        self.init_project()

    def run_sampling(self)->None:
        print(self.module_manager.module_pools)
        self.test_assembly_line()

    def test_assembly_line(self):
        if self.args.testcalculator:
            try:
                param = next(self.sampler)
                # print(self.factory.config['Scan'])
                sample = Sample(param)
                sample.set_config(deepcopy(self.info['sample']))
                future = self.factory.submit_task(sample.params, sample.info)
                # 等待任务完成并获取结果
                likelihood = future.result()
                print(likelihood)
            except Exception as e:
                # 异常处理
                print(f"An error occurred: {e}")




    def check_init_args(self) -> None:
        try:
            self.args = self.argparser.parse_args()
        except argparse.ArgumentError as e:
            print(str(e))
            self.argparser.print_help()
            sys.exit(2)




    class __StateSaver:
        def __init__(self, 
                     obj, 
                     filename='my_object.pkl', 
                     save_interval_seconds=30, 
                     logger=logging.getLogger('MyClassStateSaver')
            ):
            self.obj = obj  # Save the outside object 
            self.filename = os.path.abspath(filename)
            self.save_interval_seconds = save_interval_seconds
            self.logger = logger
            self.timer = None
            self.start_auto_save()
            self.logger.warning(f"Started successfully, Jarvis-HEP create the storage station -> {self.filename}")

        def save_state(self):
            try:
                with open(self.filename, 'wb') as f:
                    dill.dump(self.obj, f)
                self.logger.info(f"Progress has been saved to hard disk space -> {self.filename}")
            except Exception as e:
                self.logger.error(f"Failed to save state: {e}")

        def start_auto_save(self):
            """Start auto saving mission"""
            self.timer = Timer(self.save_interval_seconds, self.auto_save)
            self.timer.daemon = True
            self.timer.start()

        def auto_save(self):
            """Auto saving the object, and restart the timer"""
            self.save_state()
            self.start_auto_save()  # save the state, restart the auto save 

        def stop_auto_save(self):
            """Stop auto saving method"""
            if self.timer is not None:
                self.timer.cancel()
                self.timer = None



def load_args_config(json_file):
    with open(json_file, 'r') as file:
        config = json.load(file)
    return config
