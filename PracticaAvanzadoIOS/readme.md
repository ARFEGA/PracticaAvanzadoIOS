#PRACTICA: 
#Fundamentos de Programación iOS con Swift

- Puntos opcionales, 12 y carga de datos json no implementados.
- En la carpeta "VideoApp", hay un video demostrativo del funcionamiento de la app.
- Declaración de referencias cruzadas a weak para un correcto funcionamiento de la propiedad retainCount, tales como:
	- weak var season:Season? (Epiosdes.swift)
	
	
- El detailVC de las season, muestra el resumen de la misma, este es extenso, pero se puede hacer scroll.

- Los detalles de members y de episodes, con vuestro permiso, puesto que ya había practicado crear un VC de detalle con las seasons, he reutilizado el wikiVC, para mostrar las correspondientes wikis y así practicar con el tipo de dato AnyObject.

- Para el punto 8, he creado la siguiente función que recibe un parametro de tipo Slogan, que es una enum y devuelve la casa a la que se corresponde el Slogan, probada en test. Adicionalmente, la función está guardada en un snippet que se puede implementar o llamar empezando a escribir my.
	- func houseBySlogan(slogan:Slogan) -> House{
        let house=houses.filter{ $0.words.uppercased() == slogan.rawValue.uppercased()}.first
        return house!
    }
    
- En el punto 11 se nos pide evitar ser redundante en el momento de crear un person. Lo que se me ha ocurrido es dentro del init de person, lanzar house.add(person: self). Espero sea la solución que pedías.

- En AppDelegate he creado una struct, a la que accedo para almacenar el boton pulsado de tabBar y así mostrar el VC en el detalle del split de manera correcta en cada momento, se llama ViewsState:viewsState?


