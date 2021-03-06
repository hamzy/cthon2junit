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

require "rexml/document"

require "pp"

module Cthon
    class Special
        attr :file
        attr :testsuite

        def initialize(name, file)
            @file = file
            @testsuite = Cthon::TestSuite.new(name)
            @testsuite.expected = 1
        end

        def parse
            @contents = ""
            begin
                open(@file) do |file|
                    lines = file.readlines
                    @contents = lines.join
                end
            rescue
                puts "WARNING: Failed to open file ", @file
                errmsg = "Connectathon Special test output file was not found!!"
                @testsuite.stdout = errmsg
                test = Cthon::Test.new("Special test failure")
                test.success = false
                test.msg = errmsg
                @testsuite << test
                return
            end
            parsestr(@contents)
        end

        def parsestr(contents)
            @testsuite.stdout = contents

            @success = false
            if contents =~ /All tests completed/
                @success = true
            end

            @test = Cthon::Test.new("Special Tests")
            @test.msg = @testsuite.stdout
            if @success
                @test.success = true
            else
                @test.success = false
            end

            @testsuite << @test
        end
    end
end
