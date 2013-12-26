person1 = {first: "Joe", last: "Schmoe"}
person2 = {first: "Sarah", last: "Schmoe"}
person3 = {first: "Pete", last:"Parker"}

params = {father: person1, mother: person2, child: person3}

puts params[:father][:first]
puts params[:child][:last]

