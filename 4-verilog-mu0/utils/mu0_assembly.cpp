#include "mu0.hpp"

#include <cctype>
#include <cassert>

/*  Label syntax:
    - size >2
    - Alphanumeric + _ characters
    - Ends with a :
*/
bool mu0_is_label_decl(const string &s)
{
    if(s.size()<2){
        return false;
    }

    if(!(isalpha(s[0]) || s[0]=='_')){
        return false;
    }

    for(int i=1; i<s.size()-1; i++){
        if(!(isalnum(s[i]) || s[i]=='_')){
            return false;
        }
    }

    if(!(s.back()==':')){
        return false;
    }

    return true;
}

/*  - Check if it is numeric (with exception of sign +-)
*/
bool mu0_is_data(const string &s)
{
    if(s.empty()){
        return false;
    }

    int pos=0;  // Skip the sign
    if(s[pos]=='-' || s[pos]=='+'){
        pos=pos+1;
    }

    while(pos < s.size()){
        if(!isdigit(s[pos])){
            return false;
        }
        pos++;
    }

    return true;
}

// Goes through all these cases and checks if they are operands
bool mu0_is_instruction(const string &s)
{
    if(s=="LDA") return true;
    if(s=="STO") return true;
    if(s=="ADD") return true;
    if(s=="SUB") return true;
    if(s=="JMP") return true;
    if(s=="JGE") return true;
    if(s=="JNE") return true;
    if(s=="STP") return true;
    if(s=="OUT") return true;
    return false;
}


// Only STP and OUT do not have operands
bool mu0_instruction_has_operand(const string &s)
{
    assert(mu0_is_instruction(s));
    return !( s=="STP" || s=="OUT" );
}
