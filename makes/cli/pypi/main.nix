# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{makePythonPypiEnvironment, ...}:
makePythonPypiEnvironment {
  name = "cli-pypi";
  sourcesYaml = ./pypi-sources.yaml;
}
