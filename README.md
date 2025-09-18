# AddOptionalTrue

This is a script to add `optional: true` to `belongs_to` in the target files.

In Rails 5.0, a setting called `config.active_record.belongs_to_required_by_default` was introduced. When it's set to `true`, all existing `belongs_to` associations will behave as `optional: false`, and a validation will be added to check if the associated record exists. This might be fine for small applications where the impact is clear. However, for large applications, it's difficult to investigate the full impact. In such cases, adding `optional: true` helps maintain the current behavior of existing `belongs_to` associations, allowing a gradual shift toward the Rails default configuration.

## Usage

```bash
git clone https://github.com/willnet/add_optional_true.git
cd add_optional_true
bundle install
bundle exec ruby-rewrite -l lib/add_optional_true.rb -m your_ruby_file_or_directory
```