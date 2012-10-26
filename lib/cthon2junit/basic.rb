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
    class Basic
        attr :file
        attr :testsuite

        def initialize(name, file)
            @file = file
            @testsuite = Cthon::TestSuite.new(name)
            @testsuite.expected = 1
            @test = nil
            @order = 1
        end

        def parse

            begin
                openfile = open(@file)
            rescue
                puts "WARNING: Failed to open file ", @file
                errmsg = "Connectathon Basic test output file was not found!!"
                @testsuite.stdout = errmsg
                test = Cthon::Test.new("Basic test failure")
                test.success = false
                test.msg = errmsg
                @testsuite << test
                return
            end

            parsestr(openfile)
        end

        def parsestr(lines)
            @content = ""
            @success = false
            lines.each do |line|
                @testsuite.stdout += line
                if line =~ /Congratulations, you passed the basic tests!/
                    @success = true
                end
            end

            @test = Cthon::Test.new("Basic Tests")
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
