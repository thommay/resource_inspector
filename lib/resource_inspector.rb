require "chef/cookbook_loader"
require "chef/cookbook/file_vendor"
require "chef/cookbook/file_system_file_vendor"
require "chef/resource/lwrp_base"
require "chef/run_context"
require "chef/node"

module ResourceInspector
  def self.vomit_resources(path)
    path = File.expand_path(path)
    dir, name = File.split(path)
    Chef::Cookbook::FileVendor.fetch_from_disk(path)
    loader = Chef::CookbookLoader.new(dir)
    cookbooks = loader.load_cookbooks
    resources = cookbooks[name].files_for(:resources)

    res = {}
    resources.each do |r|
      pth = r["full_path"]
      cur = Chef::Resource::LWRPBase.build_from_file("copy_file", pth, Chef::RunContext.new(Chef::Node.new, nil, nil))
      data = {}
      data[:description] = cur.description
      data[:actions] = cur.actions
      data[:examples] = cur.examples
      data[:properties] = cur.properties.
        reject { |_, k| k.options[:declared_in] == Chef::Resource }.
        each_with_object([]) do |(n, k), acc|
        opts = k.options
        acc << { name: n, description: opts[:description], introduced: opts[:introduced], is: opts[:is], deprecated: opts[:deprecated] || false }
      end
      res[cur.resource_name] = data
    end

    res
  end
end
