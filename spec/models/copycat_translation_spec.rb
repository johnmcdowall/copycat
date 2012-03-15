require 'spec_helper'

describe CopycatTranslation do

  it "imports YAML" do
    Factory(:copycat_translation, :key => "en.sample_copy", :value => "copyfoo")
    Factory(:copycat_translation, :key => "sample_copy2", :value => "copybaz")

    assert CopycatTranslation.find_by_key("en.sample_copy").value == "copyfoo"
    assert CopycatTranslation.find_by_key("sample_copy2").value == "copybaz"
    assert CopycatTranslation.find_by_key("en.hello").nil?

    yaml = <<-YAML
      en:
        hello: "Hello world"
        sample_copy: "lorem ipsum"   
    YAML
    CopycatTranslation.import_yaml(YAML.load(StringIO.new(yaml)))

    assert CopycatTranslation.find_by_key("en.sample_copy").value == "lorem ipsum"
    assert CopycatTranslation.find_by_key("sample_copy2").value == "copybaz"
    assert CopycatTranslation.find_by_key("en.hello").value == "Hello world"
  end

  it "exports YAML" do
    Factory(:copycat_translation, :key => "sample_copy", :value => "copyfoo")
    Factory(:copycat_translation, :key => "sample_copy2", :value => "copybaz")
    yaml = CopycatTranslation.export_yaml
    assert yaml =~ /sample_copy: copyfoo\n\s*sample_copy2: copybaz/
    
    Factory(:copycat_translation, :key => "a.sample_copy3", :value => "copyfoo")
    Factory(:copycat_translation, :key => "a.sample_copy4", :value => "copybaz")
    yaml = CopycatTranslation.export_yaml
    assert yaml =~ /a:\n\s*sample_copy3: copyfoo\n\s* sample_copy4: copybaz/
  end

end




