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
    class Test
        attr_accessor :name
        attr_accessor :order
        attr_accessor :msg
        attr_accessor :success
        attr_accessor :time
        
        def initialize(name, order=1, msg="", success=true)
            @name = name
            @order = order
            @msg = msg
            @success = success
            @time = 0
        end
        
        def to_xml
            doc = REXML::Document.new
            test = doc.add_element("testcase")
            test.attributes["name"] = @name
            test.attributes["time"] = @time.to_s
            if not @success
                failure = test.add_element("failure")
                failure.attributes["message"] = @msg.to_s
            else 
                success = test.add_element("success")
                success.attributes["message"] = @msg.to_s
            end
            return doc
        end
    end
end
