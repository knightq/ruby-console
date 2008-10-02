#!/usr/bin/ruby

if __FILE__ == $0
  puts "This is a module, don't run it from the command line."
  exit
end

class String
  def color(*arg)                         # colorize a string
    if arg.length == 0                    # when no arguments are given
      arg = [:normal, :red, :bg_default]  # make it red
    end
    attribute = {         # mapper for the attributes
      :normal     => 0,
      :bright     => 1,
      :dim        => 2,
      :underscore => 4,
      :blink      => 5,
      :reverse    => 7,
      :hidden     => 8
    }
    fg_color = {          # mapper for the foreground color
      :black   => 30,
      :red     => 31,
      :green   => 32,
      :yellow  => 33,
      :blue    => 34,
      :magenta => 35,
      :cyan    => 36,
      :white   => 37,
      :default => 39
    }
    bg_color = {          # mapper for the background color
      :bg_black   => 40,
      :bg_red     => 41,
      :bg_green   => 42,
      :bg_yellow  => 43,
      :bg_blue    => 44,
      :bg_magenta => 45,
      :bg_cyan    => 46,
      :bg_white   => 47,
      :bg_default => 49
    }
    if arg.length > 0                 # turn symbols into numbers
      arg[0] = attribute[arg[0]]      # attributes
    end
    if arg.length > 1
      arg[1] = fg_color[arg[1]]       # foreground color
    end
    if arg.length > 2
      arg[2] = bg_color[arg[2]]       # background color
    end
    "\e[" + arg.join(";") + "m" + self + "\e[0m"   # magic ansi
                                                   # escape sequence
  end
end

def reset           # reset the terminal
  print "\ec"       # *42*
end

def getCursPos
  row = ""
  col = ""
  c = ""

  mapper = {
    ?\e => "\e",
    ?0  => "0",
    ?1  => "1",
    ?2  => "2",
    ?3  => "3",
    ?4  => "4",
    ?5  => "5",
    ?6  => "6",
    ?7  => "7",
    ?8  => "8",
    ?9  => "9",
    ?;  => ";",
    ?R  => "R",
    ?[  => "["
  }

  system("stty raw -echo")
  print "\e[6n"
  while (c = mapper[STDIN.getc]) != ";"
    if c == "\e" or c == "["
      next
    else
      row += c
    end
  end
  while (c = mapper[STDIN.getc]) != "R"
    col += c
  end
  system("stty -raw echo")

  [row, col]
end

def setCursPos(*arg)
  row = 0
  col = 0
  if arg.length > 0
    row = arg[0]
  end
  if arg.length > 1
    col = arg[1]
  end
  print "\e[" + row.to_s + ";" + col.to_s + "H"
end

