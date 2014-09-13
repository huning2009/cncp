# Default user for compute engine
user "cncp" do
  comment "Complex networks, complex processes"
  gid "users"
  home "/home/cncp"
  shell "/bin/bash"
  supports :manage_home => true
end

# Install SSH key into ~/.ssh
directory "/home/cncp/.ssh" do
  owner "cncp"
  group "users"
  mode "700"
end
cookbook_file "authorized_keys" do
  path "/home/cncp/.ssh/authorized_keys"
  owner "cncp"
  group "users"
  mode "600"
end

