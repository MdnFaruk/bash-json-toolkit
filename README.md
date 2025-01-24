# jsn - Command Line JSON Processor
jsn-cli - Lightweight Bash JSON Parser for Quick Data Extraction.. A simple yet powerful command-line tool for slicing JSON data without dependencies.

## Features
- Extract values by key
- Show top-level keys
- Array index support
- JSON formatting
- Error handling

## Installation

1. Download the script:
```bash
sudo curl -L https://raw.githubusercontent.com/MdnFaruk/bash-json-toolkit/main/jsn.sh -o /usr/local/bin/jsn
```

2. Make it executable:
```bash
sudo chmod +x /usr/local/bin/jsn
```

3. Verify installation:
```bash
jsn --help
```

## Usage

Basic syntax:
```bash
jsn [OPTIONS] JSON_STRING [KEY] [INDEX]
```

### Examples

1. Get value by key:
```bash
jsn '{"name":"Alice","age":30}' name
```

2. Get array element:
```bash
jsn '{"colors":["red","green"]}' colors 1
```

3. List top-level keys:
```bash
jsn -k '{"id":123,"tags":["a","b"]}'
```

4. Format JSON:
```bash
jsn '{"a":1,"b":[2,3]}'
```

## Limitations
- Doesn't support nested objects
- Simple regex-based parsing
- No JSON validation

## Requirements
- Bash 4.4+
- coreutils
