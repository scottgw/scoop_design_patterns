note
	description: "Summary description for {STRING_HELPER}."
	author: ""
	date: "$Date: 2012-05-11 09:31:21 +0200 (Fri, 11 May 2012) $"
	revision: "$Revision: 2803 $"

class
	STRING_HELPER

feature
	separate_str (a_str: STRING): detachable separate STRING
		local
			sep_str: separate STRING
		do
			create sep_str.make (a_str.count)
			make_separate_string (a_str, sep_str)
			Result := sep_str
		end

	local_str (a_str: separate STRING): STRING
		local
			i: INTEGER
		do
			create Result.make (a_str.count)
			from
				i := 1
			until
				i > a_str.count
			loop
				Result.append_character (a_str [i])
				i := i + 1
			end
		end

	make_separate_string (a_str: STRING; a_sep_str: separate STRING)
		local
			i: INTEGER
			j: INTEGER
		do
			from i := 1
			until i > a_str.count
			loop
				a_sep_str.append_character (a_str [i])
				j := a_sep_str.count -- This synchronous call ensures that the character got appended.
				-- a_sep_str [i] := a_str [i]
				i := i + 1
			end
		end
end
