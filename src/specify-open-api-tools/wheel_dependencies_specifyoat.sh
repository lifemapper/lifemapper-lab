#!/bin/bash
#
# This script defines the order of dependency installation for the current python wheel 
#
#  

OPENAPICORE_DEPS="attrs zipp importlib-metadata setuptools pyrsistent jsonschema openapi-schema-validator isodate more-itertools Werkzeug lazy-object-proxy PyYAML openapi-spec-validator six parse" 
# Flask and dependencies installed separately: "MarkupSafe Jinja2 click itsdangerous Werkzeug Flask"
# requests and dependencies installed separately: "chardet certifi idna urllib3 requests" 
OPENAPI3_DEPS="PyYAML openAPI3" # and requests
SPECIFY_OAT_DEPS="simplejson termcolor setuptools dataclasses"
