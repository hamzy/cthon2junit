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

module Cthon
    class TestSuite
        attr :name
        attr_accessor :expected
        attr_accessor :skip        
        attr_accessor :stdout
        
        def initialize(name)
            @name = name
            @tests = []
            @stdout = ""
            @expected = 0
        end

        def total 
            return @tests.size
        end
        
        def passed 
            count = 0
            @tests.each do |test|
                if test.success
                    count += 1
                end
            end
            return count
        end
        
        def failed
            count = 0
            @tests.each do |test|
                if not test.success
                    count += 1
                end
            end
            return count
        end
        
        def <<(test)
            @tests << test
        end
      
        def to_xml
            time = 0
           
            doc = REXML::Document.new
            testsuite = doc.add_element("testsuite")
            testsuite.add_attribute("name", @name)
            
            while (total < @expected) 
                num = @expected - total
                test = Test.new("missing test ##{num}", 
                                "This failure was injected because less tests were run than expected",
                                false)
                test.success = false
                @tests << test
            end
            
            @tests.each do |test|
                testsuite.add_element(test.to_xml)
                time += test.time
            end
                        
            testsuite.add_attribute("tests", total.to_s)
            testsuite.add_attribute("failures", failed.to_s)
            testsuite.add_attribute("time", time.to_s)
            stdout = testsuite.add_element("system-out")
            stdout.text = @stdout
            return doc
        end
        
    end
end
