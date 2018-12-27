#!ruby
#
# Written by Zoran Lazarevic
# http://www.cs.columbia.edu/~laza/
# This is free software
#


require "mycin.rb"

# Regra padrão do Mycin, alterada para a necessidade do nosso cliente
#
#            param  context
#            -----  -------
#
#   (defrule 52
#       if  (site   culture         is  blood )
#           (gram   organism        is  neg   )         <--- premise/condition
#           (morphl organism        is  rod   )
#           (burn   patient         is  serious)
#       then 0.4                                        <--- confidence factor (cf)
#           (identity   organism    is  pseudomonas )   <--- conclusion
#   )
#
#  context: patients, cultures, and organisms
#
#

class Member < MemberVerification
end

def main

    db = EMycin.new             # Novo banco de dados Mycin

#
# Operacoes que serao realizadas com os parametros
#
    db.add_operation("is", proc{|a,b| a == b })
    db.add_operation("vol", proc{|a,b| a >= b })
    db.add_operation("nvol", proc{|a,b| a <= b })
    
    # processos de verificacao dos parametros
    yes_no      = Member.new(["sim","nao"])
    is_number   = ReplyVerification.new( proc{|x,args| x.to_i.to_s == x }, proc{|a| "Must be a number" })

    # Parametros para 'situacao' 
    db.add_parameter("convergencia",  "situacao", yes_no, "Existe convergencia? ", Ask_First)
    db.add_parameter("acumulado",  "situacao", yes_no, "O acumulado ultrapassa os 30mm nas ultimas 3 horas? ", Ask_First)
    db.add_parameter("CTR", "situacao", yes_no, "O CTR indica movimentacao em direcao a RMR?", Ask_First)
    db.add_parameter("indicador",  "situacao", Member.new(["chuva","nao_chuva"]), "Qual o parametro da situacao?",  Ask_First)  
    db.add_parameter("volume", "situacao", is_number, "Volume ", Ask_First)
#
# Define as regras
# As regras se baseiam nos termos repassados aos parâmetros
#
    
    db.add_rule( 50, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is sim"), 
            db.new_premise("acumulado situacao is nao"), 
            db.new_premise("CTR  situacao is nao") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.9 )
    db.add_rule( 51, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is nao"), 
            db.new_premise("acumulado situacao is sim"), 
            db.new_premise("CTR  situacao is nao") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.5 )
    db.add_rule( 52, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is nao"), 
            db.new_premise("acumulado situacao is nao"), 
            db.new_premise("CTR  situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.5 )
    db.add_rule( 53 , 
        [   db.new_premise("convergencia situacao is sim"),
            db.new_premise("acumulado situacao is sim"), 
            db.new_premise("volume situacao nvol 30"), 
            db.new_premise("CTR situacao is nao") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.8 )
    db.add_rule( 54 , 
        [   db.new_premise("convergencia situacao is sim"),
            db.new_premise("acumulado situacao is nao"), 
            db.new_premise("volume situacao nvol 30"), 
            db.new_premise("CTR situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.8 )
    db.add_rule( 55 , 
        [   db.new_premise("acumulado situacao is sim"),
            db.new_premise("convergencia situacao is nao"), 
            db.new_premise("volume situacao nvol 30"), 
            db.new_premise("CTR situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.7 )
    db.add_rule( 56, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is sim"), 
            db.new_premise("acumulado situacao is sim"), 
            db.new_premise("CTR  situacao is nao") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.9 )
    db.add_rule( 57, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is sim"), 
            db.new_premise("acumulado situacao is nao"), 
            db.new_premise("CTR  situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.9 )
    db.add_rule( 58, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is nao"), 
            db.new_premise("acumulado situacao is sim"), 
            db.new_premise("CTR  situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.8 )
    db.add_rule( 59 , 
        [   db.new_premise("convergencia situacao is sim"),
            db.new_premise("acumulado situacao is sim"), 
            db.new_premise("volume situacao nvol 30"), 
            db.new_premise("CTR situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
        0.8 )
    db.add_rule( 60, 
        [   db.new_premise("volume situacao vol  30"),
            db.new_premise("convergencia situacao is sim"), 
            db.new_premise("acumulado situacao is sim"), 
            db.new_premise("CTR  situacao is sim") ] , 
        [   db.new_conclusion("indicador situacao is chuva") ] ,
	1.0 )
   # db.add_rule( 53, 
   #     [   db.new_premise("volume situacao nvol 30"), 
   #         db.new_premise("CTR situacao is nao"),
   #         db.new_premise("acumulado situacao is sim"), 
   #         db.new_premise("convergencia situacao is nao") ] , 
   #     [   db.new_conclusion("indicador situacao is chuva") ] ,
   #     0.4 )
    db.add_rule( 61, 
        [   db.new_premise("volume situacao nvol 30"), 
            db.new_premise("CTR situacao is nao"), 
            db.new_premise("acumulado situacao is nao"), 
            db.new_premise("convergencia situacao is nao") ] , 
        [   db.new_conclusion("indicador situacao is nao_chuva") ] ,
	1.0 )
    #db.add_rule( 55, 
    #    [   db.new_premise("volume situacao vol 30"), 
    #        db.new_premise("CTR situacao is nao"), 
    #        db.new_premise("acumulado situacao is nao"), 
    #        db.new_premise("convergencia situacao is nao") ] , 
    #    [   db.new_conclusion("indicador situacao is nao_chuva") ] ,
#	0.4)
    #db.add_rule( 56, 
    #    [   db.new_premise("volume situacao nvol 30"), 
    #        db.new_premise("CTR situacao is nao"), 
    #        db.new_premise("acumulado situacao is nao"), 
    #        db.new_premise("convergencia situacao is sim") ] , 
    #    [   db.new_conclusion("indicador situacao is nao_chuva") ] ,
#	0.3 )



#
# Define as questões que devem ser feitas e o objetivo que se busca parametrizar
#

    contexts = [
        Context.new("situacao", ["volume", "convergencia", "acumulado", "CTR"]), # Ask about the situation 
	Context.new("situacao", [], ["indicador"])
        ]
#
# Now run the expert system. User will be asked questions, thus populating 
# the database
#
    db.run contexts

#
# Done.
#
    db.clear

end




$tracefuncs = ["find_out", "get_known", "aks_vals", "use_rules", "reject_premise",
            "satisfy_premises", "eval_condition"]

class TraceCalls
  def initialize(n)
    @level = n
  end
  def func
    return proc {|event, file, line, id, binding, classname|
      case event
        when "c-call", "call"
          if $tracefuncs.member?(id.to_s) then
              printf("%18s %6d", file, line)
              (2*@level).times do print " " end
              print "call ", classname, ".", id, "\n"
              @level += 1
          end
        when "c-return", "return"
          if $tracefuncs.member?(id.to_s) then
              printf("%18s %6d", file, line)
              @level -= 1
              (2*@level).times do print " " end
              print "exit ", classname, ".", id, "\n"
          end
      end
    }
  end
end

# set_trace_func TraceCalls.new(1).func

main



=begin

#
# This is a result of a test run
# The example is from the book.
#

>test_mycin.rb

------- patient-1 -------

Patient's name:  HELP
 Type one of the following:
    ?       - to see possible answers for this parameter
    rule    - to show current rule
    why     - to see why this question is asked
    help    - to see this list
    xxx     - (for some specific xxx) if there is a definite answer
    xxx .5 yyy .4 - if there are several answers with
                different certainty factors

Patient's name:  SYLVIA_FISHER

Sex:  FEMALE

Age:  27
------- culture-1 -------

From what site was specimen CULTURE-1 taken?  BLOOD

How many days ago was this culture (CULTURE-1) obtained?  3
------- organism-1 -------

Enter the identity (genus) of ORGANISM-1?  UNKNOWN

The gram strain of ORGANISM-1?  ?
Must be one of: acid-fast, pos, neg


The gram strain of ORGANISM-1?  NEG

Is ORGANISM-1 a rod or coccus?  ROD

Is PATIENT-1 a burn patient? If so, mild or serious? WHY
[Why is the value of burn being asked for?]
It is known that:
    The site of the culture is blood
    The gram of the organism is neg
    The morphology of the organism is rod
Therefore,
Rule 52:
    If  The burn of the patient is serious
    Then with certainty of 0.4
        The identity of the organism is pseudomonas


Is PATIENT-1 a burn patient? If so, mild or serious? SERIOUS

What is the aerobicity of ORGANISM-1? AEROBIC

Is PATIENT-1 a compromised host?  YES
Findings for ORGANISM-1
    for these goals: identity
    IDENTITY: ENTERO 0.8, PSEUDOMONAS 0.76

Is there another organism?YES
------- organism-2 -------

Enter the identity (genus) of ORGANISM-2?  UNKNOWN

The gram strain of ORGANISM-2?  NEG 0.8  POS 0.2

Is ORGANISM-2 a rod or coccus?  ROD

What is the aerobicity of ORGANISM-2? ANAEROBIC
Findings for ORGANISM-2
    for these goals: identity
    IDENTITY: BACTEROIDES 0.72, PSEUDOMONAS 0.6464

Is there another organism?NO
Is there another culture?NO
Is there another patient?NO

=end
