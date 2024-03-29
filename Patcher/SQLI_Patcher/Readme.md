# SQLite3/Ruby Interface
[![Build Status](https://github.com/makandra/angular_xss/workflows/Tests/badge.svg)](https://github.com/Malwareman007/Open_Source_Web-Vulnerability-Scanner-and-Patcher/actions)
## DESCRIPTION

  This module allows Ruby programs to interface with the SQLite3
  database engine (http://www.sqlite.org).  You must have the
  SQLite engine installed in order to build this module.

***Note that this module is NOT compatible with SQLite 2.x.***

## SYNOPSIS

  require `sqlite3`
  
  ### Open a database
  db = SQLite3::Database.new `test.db`
  
  * Create a database
  `rows = db.execute <<-SQL
    create table numbers (
      name varchar(30),
      val int
    );
  SQL`
  
  * Execute a few inserts
  `{
    "one" => 1,
    "two" => 2,
  }.each do |pair|
    db.execute "insert into numbers values ( ?, ? )", pair
  end`
  
  * Find a few rows
  `db.execute( "select * from numbers" ) do |row|
    p row
  end`


## Compilation and Installation

Install SQLite3, enabling option SQLITE_ENABLE_COLUMN_METADATA (see
www.sqlite.org/compile.html for details).

Then do the following:
```
  ruby setup.rb config
  ruby setup.rb setup
  ruby setup.rb install
```
***Alternatively, you can download and install the RubyGem package for
SQLite3/Ruby (you must have RubyGems and SQLite3 installed, first):***

 ``` 
 gem install sqlite3-ruby
 ```

***If you have sqlite3 installed in a non-standard location, you can specify the location of the include and lib files by doing:***
```
  gem install sqlite3-ruby -- --with-sqlite3-include=/opt/local/include \
     --with-sqlite3-lib=/opt/local/lib
```
# SUPPORT!!!

## OMG!  Something has gone wrong!  Where do I get help?

The best place to get help is from the
mailing  which
can be found here:

  * http://groups.google.com/group/sqlite3-ruby

## I've found a bug!  Where do I file it?

Uh oh.  After contacting the mailing list, you've found that you've actually
discovered a bug.  You can file the bug at the
[github issues page](https://github.com/Malwareman007/Scanner-and-Patcher/issues)
which can be found here:

  * https://github.com/Malwareman007/Scanner-and-Patcher/issues

## Usage

For help figuring out the SQLite3/Ruby interface, check out the
[FAQ](http://sqlite-ruby.rubyforge.org/sqlite3/faq.html). It includes examples of
usage. If you have any questions that you feel should be address in the
FAQ, please send them to ojhakushagra73@gmail.com

## Source Code

The source repository is accessible via git:
```
  git clone git://github.com/Malwareman007/Open_Source_Web-Vulnerability-Scanner-and-Patcher.git
```
