#!/usr/bin/ruby
#
# Copyright IBM  (2012)
# Author(s): Sean Dague      sdague@us.ibm.com
#            Jeremy Bongio   jbongio@us.ibm.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ---------------------------------------

home = ARGV[0]
results = ARGV[1] || "/tmp"
prefix = ARGV[2] || ""
udp = ARGV[3] || "noudp"
krbtested = ARGV[4] || "nokrb"
version = ARGV[5] || "v3"

require "./lib/cthon2junit.rb"

# clean up xml files
Dir.chdir(home) do |path|
    files = Dir.glob("#{prefix}*.xml")
    files.each do |file|
        File.delete(file)
    end
end

security = []
if krbtested != "nokrb"
    security = ["-krb5", "-krb5i", "-krb5p"]
else
    security = ['']
end

security.each do |sec|
    # Basic
    b3t = Cthon::Basic.new("NFS#{version} TCP Basic Tests", "#{results}/nfs#{version}tcp-b#{sec}")
    b3t.parse
    File.open("#{home}/#{prefix}nfs#{version}tcp-b#{sec}.xml", "w") do |file|
        file.write(b3t.testsuite.to_xml)
    end
    
    
    if udp != "noudp"
        b3u = Cthon::Basic.new("NFS#{version} UDP Basic Tests", "#{results}/nfs#{version}udp-b#{sec}")
        b3u.parse
        File.open("#{home}/#{prefix}nfs#{version}udp-b#{sec}.xml", "w") do |file|
            file.write(b3u.testsuite.to_xml)
        end
    end
    
    #General
    g3t = Cthon::General.new("NFS#{version} TCP General Tests", "#{results}/nfs#{version}tcp-g#{sec}")
    g3t.parse
    File.open("#{home}/#{prefix}nfs#{version}tcp-g#{sec}.xml", "w") do |file|
        file.write(g3t.testsuite.to_xml)
    end
    
    
    if udp != "noudp"
        g3u = Cthon::General.new("NFS#{version} UDP General Tests", "#{results}/nfs#{version}udp-g#{sec}")
        g3u.parse
        File.open("#{home}/#{prefix}nfs#{version}udp-g#{sec}.xml", "w") do |file|
            file.write(g3u.testsuite.to_xml)
        end
    end
    
    #Special
    s3t = Cthon::Special.new("NFS#{version} TCP Special Tests", "#{results}/nfs#{version}tcp-s#{sec}")
    s3t.parse
    File.open("#{home}/#{prefix}nfs#{version}tcp-s#{sec}.xml", "w") do |file|
        file.write(s3t.testsuite.to_xml)
    end
    
    if udp != "noudp"
        s3u = Cthon::Special.new("NFS#{version} UDP Special Tests", "#{results}/nfs#{version}udp-s#{sec}")
        s3u.parse
        File.open("#{home}/#{prefix}nfs#{version}udp-s#{sec}.xml", "w") do |file|
            file.write(s3u.testsuite.to_xml)
        end
    end
    
    #Locking
    l3t = Cthon::Locking.new("NFS#{version} TCP Locking Tests", "#{results}/nfs#{version}tcp-l#{sec}")
    l3t.parse
    File.open("#{home}/#{prefix}nfs#{version}tcp-l#{sec}.xml", "w") do |file|
        file.write(l3t.testsuite.to_xml)
    end
    
    if udp != "noudp"
        l3u = Cthon::Locking.new("NFS#{version} UDP Locking Tests", "#{results}/nfs#{version}udp-l#{sec}")
        l3u.parse
        File.open("#{home}/#{prefix}nfs#{version}udp-l#{sec}.xml", "w") do |file|
            file.write(l3u.testsuite.to_xml)
        end
    end
end    

