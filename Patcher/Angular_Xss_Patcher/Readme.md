angular_xss [![Build Status](https://github.com/makandra/angular_xss/workflows/Tests/badge.svg)](https://github.com/makandra/angular_xss/actions)
===========

When rendering AngularJS templates with a server-side templating engine like ERB or Haml it is easy to introduce XSS vulnerabilities. These vulnerabilities are enabled by AngularJS evaluating user-provided strings containing interpolation symbols (default symbols are `{{` and `}}`).

This gem patches ERB/rails_xss and Haml so Angular interpolation symbols are auto-escaped in unsafe strings. And by auto-escaped we mean replacing `{{` with `{{ $root.DOUBLE_LEFT_CURLY_BRACE }}`. To leave AngularJS interpolation marks unescaped, mark the string as `html_safe`.

**This is an unsatisfactory hack.** A better solution is very much desired, but is not possible without some changes in AngularJS. See the [related AngularJS issue](https://github.com/angular/angular.js/issues/5601).


Disable escaping locally
------------------------

If you want to disable angular_xss in some part of your app, you can use

```
AngularXss.disable do
  # no escaping here
end
# escaped again
```


Installation
------------

0. Read the code so you know what you're getting into.

1. Put this into your Gemfile **after other templating engines** like Haml or Erubis:

        gem 'angular_xss' # put me after Haml, Erubis and other templating engines

2. Run `bundle install`.

3. Add this to your Angular code (replacing "myApp" of course):

   ```
   angular.module('myApp', []).run(['$rootScope', function($rootScope) {
     $rootScope.DOUBLE_LEFT_CURLY_BRACE = '{{';
   }]);
   ```

4. Run your test suite to find the places that broke.

5. Mark any string that is allowed to contain Angular expressions as `#html_safe`.


Known limitations
-----------------
- Requires Haml. It could be refactored to only patch ERB/rails_xss.
- When using Haml with angular_xss, you can no longer use interpolation symbols in `class` or `id` attributes,
  even if the value is marked as `html_safe`. This is a limitation of Haml. Try using `ng-class` instead.


Development
-----------

- Fork the repository.
- Push your changes with specs. There is a Rails 3 test application in `spec/app_root` if you need to test integration with a live Rails app.
- You may run single tests with a specified Rails version via `BUNDLE_GEMFILE=Gemfile.rails-7.0.haml-5 bundle exec rspec ./spec/angular_xss`
- Send a pull request.


