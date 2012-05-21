module StrongPasswordCheck
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          
          # run code for updating issue
          alias_method_chain :before_save, :pass_check
        end
      end

      module ClassMethods
      end

      module InstanceMethods   
        def before_save_with_pass_check
            if self.password_confirmation
              if self.password.match(/^#{self.login}/)
                self.errors.add_to_base(l(:message_your_pass, :log => l(:start_with_name)))
                return false
              end
              isstrongenough, strlog = strong_enough_pass(self.password)
              if !isstrongenough
                self.errors.add_to_base(l(:message_your_pass, :log => strlog)[0..-3])
                return false
              end
            end
          before_save_without_pass_check
        end

        def strong_enough_pass (passwd)
            strlog = ""
            ret = true
            unless (/[a-z]/.match passwd)                              # [verified] at least one lower case letter
              strlog   = strlog + l(:no_lowercase) + ", "
              ret = false
            end

            unless (/[A-Z]/.match passwd)                              # [verified] at least one upper case letter
              strlog   = strlog + l(:no_capital) + ", "
              ret = false
            end

            # NUMBERS
            unless (/\d+/.match passwd)                                 # [verified] at least one number
              strlog   = strlog + l(:no_numbers) + ", "
              ret = false
            end

            # SPECIAL CHAR
            unless (/[\!,\@,\#,\$,\%,\^,\&,\*,\?,\_,\~,\(,\),\[,\],\{,\},\<,\,,\>,\.,\|,\',\",\:,\\,\/,\;]/.match passwd)             # [verified] at least one spec
              strlog   = strlog + l(:no_spec) + ", "
              ret = false
            end
            return ret, strlog
        end


#        def strong_enough_pass (passwd)
#            intscore   = 0
#            #strVerdict = "weak"
#            strlog     = ""
#
#            if (passwd.length<5)                         # length 4 or less
#              intscore = (intscore+3)
#              strlog   = strlog + l(:points_length_3, :length => passwd.length) + ", "
#            elsif (passwd.length>4 && passwd.length<8) # length between 5 and 7
#              intscore = (intscore+6)
#              strlog   = strlog + l(:points_length_6, :length => passwd.length) + ", "
#            elsif (passwd.length>7 && passwd.length<16) # length between 8 and 15
#              intscore = (intscore+12)
#              strlog   = strlog + l(:points_length_12, :length => passwd.length) + ", "
#            elsif (passwd.length>15)                    # length 16 or more
#              intscore = (intscore+18)
#              strlog   = strlog + l(:points_length_18, :length => passwd.length) + ", "
#            end
#
#
#            # LETTERS (Not exactly implemented as dictacted above because of my limited understanding of Regex)
#            if (/[a-z]/.match passwd)                              # [verified] at least one lower case letter
#              intscore = (intscore+1)
#              strlog   = strlog + l(:points_lowercase) + ", "
#            end
#
#            if (/[A-Z]/.match passwd)                              # [verified] at least one upper case letter
#              intscore = (intscore+5)
#              strlog   = strlog + l(:points_capital) + ", "
#            end
#
#            # NUMBERS
#            if (/\d+/.match passwd)                                 # [verified] at least one number
#              intscore = (intscore+5)
#              strlog   = strlog + l(:points_number) + ", "
#            end
#
#            if (/(.*[0-9].*[0-9].*[0-9])/.match passwd)             # [verified] at least three numbers
#              intscore = (intscore+5)
#              strlog   = strlog + l(:points_3_number) + ", "
#            end
#
#            # SPECIAL CHAR
#            if (/.[!,@,#,$,%,^,&,*,?,_,~]/.match passwd)            # [verified] at least one special character
#              intscore = (intscore+5)
#              strlog   = strlog +  l(:points_spec) + ", "
#            end
#
#            # [verified] at least two special characters
#            if (/(.*[!,@,#,$,%,^,&,*,?,_,~].*[!,@,#,$,%,^,&,*,?,_,~])/.match passwd)
#              intscore = (intscore+5)
#              strlog   = strlog + l(:points_2_spec) + ", "
#            end
#
#
#            # COMBOS
#            if (/([a-z].*[A-Z])|([A-Z].*[a-z])/.match passwd)        # [verified] both upper and lower case
#              intscore = (intscore+2)
#              strlog   = strlog + l(:points_capital_lower) + ", "
#            end
#
#            if (/([a-zA-Z])/.match(passwd) && /([0-9])/.match(passwd)) # [verified] both letters and numbers
#              intscore = (intscore+2)
#              strlog   = strlog + l(:points_letters_numbers) + ", "
#            end
#
#            # [verified] letters, numbers, and special characters
#            if (/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/.match passwd)
#              intscore = (intscore+2)
#              strlog   = strlog + l(:points_numbers_spec) + ", "
#            end
#
#            ret = false
#            if (intscore > 24)
#              ret = true
#            end
#            return ret, intscore, strlog
#          end
      end
    end
  end
end
