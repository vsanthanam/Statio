<?php

final class CommandUnitTestEngine extends ArcanistUnitTestEngine {

    protected $console;
    protected $renderer;

    private $command;
    private $manual;
    private $buildStart;

    public function init() {
        $config_manager = $this->getConfigurationManager();
        $this->command = $this->getConfigurationManager()->getConfigFromAnySource('unit.engine.command');
        $this->manual = $this->getConfigurationManager()->getConfigFromAnySource('unit.engine.manual_exec') == "true" ? true : false;
        $this->console = PhutilConsole::getConsole();
        $this->renderer = new ArcanistUnitConsoleRenderer();
    }

    public function run() {
        $results = array();
        $this->init();
        
        $this->buildStart = microtime(true);
        $results[] = $this->execute();
        return $results;
    }
    
    public function shouldEchoTestResults() {
        return false;
    }

    private function execute() {
        $result = new ArcanistUnitTestResult();
        $result->setName($this->getConfigurationManager()->getConfigFromAnySource('unit.engine.command.name'));
        $this->console->writeOut("%s %s",
          phutil_console_format('<bg:yellow>** RUN **</bg>'),
          $result->getName()
        );

        try {
            list($stdout, $stderr) = execx($this->command);
            $this->saveDuration($result);
            $result->setResult(ArcanistUnitTestResult::RESULT_PASS);
            $this->console->writeOut("\r%s", $this->renderer->renderUnitResult($result));
        } catch(CommandException $exec) {
            $result->setUserdata($exc->getStdout() . "\n" . $exc->getStderr());
            $this->saveDuration($result);
            $result->setResult(ArcanistUnitTestResult::RESULT_FAIL);
            $this->console->writeOut("\r%s", $this->renderer->renderUnitResult($result));
        }
        return $result;
    }
    
    private function saveDuration($result) {
        $duration = microtime(true) - $this->buildStart;
        $result->setDuration($duration);
    }
}

?>
