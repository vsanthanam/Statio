<?php

final class SwiftLinter extends ArcanistExternalLinter {

    public function getInfoName() {
        return 'swift';
    }

    public function getInfoURI() {
        return 'https://code.vsanthanam.com';
    }

    public function getInfoDescription() {
        return pht('Use the swift linter in ./repo-lint');
    }

    public function getLinterName() {
        return 'repo-swift-lint';
    }

    public function getLinterConfigurationName() {
        return 'repo-swift-lint';
    }

    public function getLinterConfigurationOptions() {
        $options = array(
        );

        return $options + parent::getLinterConfigurationOptions();
    }

    public function getDefaultBinary() {
        return './repo';
    }

    public function getInstallInstructions() {
        return pht(
            'Run update-repo.sh from the repo root!'
        );
    }

    public function shouldExpectCommandErrors() {
        return true;
    }

    protected function getMandatoryFlags() {
        return array(
            'lint',
        );
    }

    protected function getPathArgumentForLinterFuture($path) {
        return csprintf('--arclint %s', $path);
    }

    protected function parseLinterOutput($path, $err, $stdout, $stderr) {
        $ok = ($err == 0);

        $lines = phutil_split_lines($stdout, false);

        $messages = array();
        foreach ($lines as $line) {
            $components = explode(":", $line);
            
            $length = count($components);
            if ($length >= 2) {
                $message = new ArcanistLintMessage();
                $message->setSeverity($this->getLintMessageSeverity($components[0]));
                $message->setLine($components[1]);
                $message->setChar($components[2]);
                $message->setDescription($components[3]);
                $message->setName($components[5]);
                $message->setPath($path);
                $message->setCode($components[4]);
                $messages[] = $message;
            }
        }
        return $messages;
    }

    protected function getDefaultMessageSeverity($code) {
        if ($code == 'error') {
            return ArcanistLintSeverity::SEVERITY_ERROR;
        } else if ($code == 'autofix') {
            return ArcanistLintSeverity::SEVERITY_AUTOFIX;
        } else {
            return ArcanistLintSeverity::SEVERITY_WARNING;
        }
    }
}

?>