use "C:\Users\rpelloquin\Desktop\egypt_all.dta"

////////////// MODELES MULTINOMIAUX ///////////////

// C'est comme pour des variables binaires mais c'est etendu à plus de catégories


//// Multinomiales non ordonnées 

// on utilise un multi logit, c'est un logit generalisé 

// HYPOTHESE D'INDEPENDANCE DES ALTERNATIVES : Si on enleve une alternative cela ne doit pas changer les B
// Le modele multilogit est possible seulement si cette hypothese est vraie

// commande ==> mlogit
// on va voir la destistination
tab dest_int_mig
// on va enlever l'année 2009 et ceux qui n'ont pas l'intention de migrer pour ne pas avoir a faire des if a toutes les equations
keep if year==2014 & intend_mig==1
tab dest_int_mig // pb une categorie a 11 individu

recode dest_int_mig(4=3)
tab dest_int_mig

mlogit dest_int_mig lnarab_expo employ i.agegroup i.educlevel  gender

// pour changer la categorie de ref
mlogit dest_int_mig lnarab_expo employ i.agegroup i.educlevel  gender, base(1)
// ce sont des logit donc on peut juste interpreter le signe et la significativité
// il n'y a pas d'effet du printemps arabe entre choisir un pays arabe ou chosiri un pays AS (qui a eu le printemps arabe)

// On peut faire des effets marginaux (prob de choisir le pays 1)et des odds ratio ou ratio de risques relatifs (RRR) qui est la prob de choisir le pays 1 par rapport au pays de ref

// on garde la modalité 2 comme ref :
mlogit dest_int_mig lnarab_expo employ i.agegroup i.educlevel  gender, base(2) rrr

// l'exposition au printemps arabe augmente de 24% la proba de migrer vers un pays europeens plutot que dans un pays arabes qui n'a pas connu le printemps arabe
// il n'y a pas d'effet du printemps arabes entre choisir differents pays arabes

// si on ne veut pas mettre de relation avec la modalité on doit passer aux effets marginaux

margins, dydx(lnarab_expo) // on va voir l'effet du printemps arabe dans la destination
// On voit qu'il y a une influance que vers les pays europeens, plus on est exposé plus on a envie de partir dans ce type de pays

margins educlevel,predict(out(1)) // est ce que le niveau d'education a une influance sur la probabilité de la categorie 1
// bcp de données donc on va faire un graphique
marginsplot, name(dest1)
margins educlevel,predict(out(2))
marginsplot, name(dest2)
margins educlevel,predict(out(3))
marginsplot, name(dest3)
graph combine dest1 dest2 dest3


// TESTER L'HYPOTHESE D'INDEPENDANCE DES ALTERNATIVES : TEST D'HOSMAN
// Plusieurs etapes : - estimer le modele de base et les garder en memoire (avec store)
//					  - estimer le modele en enlevant une alternative

mlogit dest_int_mig lnarab_expo employ i.agegroup i.educlevel  gender, base(2)
estimates store base_mlogit

mlogit dest_int_mig lnarab_expo employ i.agegroup i.educlevel  gender if dest_int_mig!=3, base(2)
estimates store partiel2_mlogit

hausman base_mlogit partiel2_mlogit
// le test ne marche pas donc l'hypothese ne peut pas être verifiée, surement car les deux alternatives sont trop proches

// modele peu adapté, soit on fait 2 catégories europe/arabe soit on utilise d'autres types de modele qui ne suppose pas cette hypothese ==> nested logit
// compliqué à mettre en place car il faudrait changer le format des données. L'interet est qu'on n'est pas obligé d'avoir les même variables explicatives selon les branches
// on peut faire un logit conditionnel aussi mais on doit quand meme mettre les données sous la meme forme
