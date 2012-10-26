#
# Copyright IBM  (2012)
# Author(s): Sean Dague      sdague@us.ibm.com
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

require File.dirname(__FILE__) + '/test_helper.rb'
require "fileutils"
class TestCli < Test::Unit::TestCase
  
  def setup
      
  end
  
  def test_general

    if not File.directory?("results")
      Dir.mkdir("results")
    end
    
    assert_equal system("./cthon2junit.rb results test/samples root-"), true
    
    assert File.exist? "results/root-nfsv3tcp-b.xml"
    assert File.exist? "results/root-nfsv3tcp-g.xml"
    assert File.exist? "results/root-nfsv3tcp-l.xml"
    assert File.exist? "results/root-nfsv3tcp-s.xml"
    assert (not File.exist? "results/root-nfsv3udp-b.xml")
    assert (not File.exist? "results/root-nfsv3udp-g.xml")
    assert (not File.exist? "results/root-nfsv3udp-l.xml")
    assert (not File.exist? "results/root-nfsv3udp-s.xml")
    
    FileUtils.rm_rf("results")
  end

  def test_general_with_udp
    if not File.directory?("results")
      Dir.mkdir("results")
    end
    
    assert_equal system("./cthon2junit.rb results test/samples root- 1"), true
    
    assert File.exist? "results/root-nfsv3tcp-b.xml"
    assert File.exist? "results/root-nfsv3tcp-g.xml"
    assert File.exist? "results/root-nfsv3tcp-l.xml"
    assert File.exist? "results/root-nfsv3tcp-s.xml"
    assert ( File.exist? "results/root-nfsv3udp-b.xml")
    assert ( File.exist? "results/root-nfsv3udp-g.xml")
    assert ( File.exist? "results/root-nfsv3udp-l.xml")
    assert ( File.exist? "results/root-nfsv3udp-s.xml")
    
    FileUtils.rm_rf("results")
  end
end
