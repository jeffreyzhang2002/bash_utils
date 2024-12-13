`command_harness.sh` contains a simple template for creating command line interfaces. We use annotations to automatically generate a help message for each user defined command

# Examples and Use
1. Create a new bash script where each custom command is inside of a function

  Example.sh
  ```bash
  #!/usr/bin/env bash

  // Code for my_command_1
  function my_command_1 {
  : @help <Enter a help message here>

  }

  // Code for my_command_2
  function my_command_2 {
  : @help <Enter a help message here>
  : @su mark this command to require root permissions

  }


  // This must be the last line of the script!
  source ./command_harness.sh
  ```

2. Now we can call custom command using this syntax

```bash
  // Display help messages for all user defined functions
  ./example.sh

  // Execute my_command_1 passing <args> to $1, $2 ...
  ./example.sh my_command_1 <args>

  // Execute my_command_2 passing <args> to $1, $2 ...
  // harness will check that you have root permissions before executing
  ./example.sh my_command_2 <args>
```

## Notes

1. `: @help` and `: @su` annotations are optional and can be placed anywhere inside of the function. Only the first one will be displayed
2. functions prefixed with two underscores will not be printed to indicate that they are private

