# Práctica 9: MBAAS con FIREBASE
## Juan A. Caballero
---------------------------------------------




DESCRIPCIÓN DE LA PRÁCTICA
---------------------------------------------
Se ha desarrollado una app que permite añadir post o noticias y subirlos a un backend de **Firebase**, en los cuales podemos incluir Titulo, Texto de la noticia, Foto, Author, etc.

Estos post podrán ser publicados por el autor en el momento de crear el post o después accediendo a cada post con la opción de borrarlo o publicarlo mediante un botón tipo Slide.


AUTENTICACIÓN
---------------------------------------------
Se ha implementado un control de acceso a través de un política de Autenticación basada en **mail y contraseña** gestionada con el backend de Firebase. 

**ZONA PÚBLICA**

La política de autenticación permite acceso anónimo a una lista de posts publicados al arrancar la app y pulsando sobre cada uno podemos ver el detalle y valorarlo mediante una barra para puntuar la valoración.

Los posts son descargados desde Firebase. 

Se permiten dos tipos de usuarios para acceder a la app. El usuario anónimo, que se genera automáticamente al arrancar la app sin usuario previamente autenticado, y usuarios con mail y contraseña.  

**ZONA PRIVADA**

El botón superior derecho que indica crear nuevo post, nos da acceso a una zona privada donde cada usuario puede ver todos sus posts, los publicados y los no publicados. Si no nos hemos logueado previamente, al pulsar este botón nos muestra una Alert con un menú para registrar nuevo usuario introduciendo ahí mail y contraseña, hacer longin o cancelar. Una vez autenticados, esta alert no vuelve a aparecer al pulsar sobre este botón. 

En la parte superior izquierda se ha incluido un botón de Logout para salir, el cual cuando se pulsa carga automáticamente el usuario Anonimous como la primera vez que accedemos. 

Se ha permitido la creación de **post sin foto**, en cuyo caso se añade automáticamente una foto similando que esta vacía (silla vacía) para mejorar la estética de los listados sin huecos en ellos.


FIREBASE DATABASE Y STORAGE
---------------------------------------------

El backend incluye una BASE DE DATOS en la cual guardaremos todos los datos de los posts organizados en dos directorios: 
	
- **Users** : De él cuelgan los distintos usuarios y de cada uno de estos todos sus posts con diccionarios que incluyen todos sus campos (titulos, descripción, postId...)
	
- **publishedPost** : De él cuelgan todos los post publicados, que son copiados aquí cada vez que se publican y eliminados de aquí también cuando se eliminan.


También se incluye un bucket de **STORAGE** del que cuelga un directorio llamado **userImage** donde se almacenan las imágenes creadas por los usuarios para cada post.


ZONA PRIVADA
---------------------------------------------
La zona privada muestra todos los post del usuario logueado y mediante un par de botones tipo slide permiten borrar y publicar cada post. 

Pulsando sobre cada post, podemos acceder a las estadísticas de valoraciones de usuarios: número de valoraciones y valoración media. 

La valoración de post se ha implementado con varias propiedades dentro del diccionario que representa cada post: número de valoraciones, valoarción media y valoración total. 

Mediante un botón "+" en la parte superior derecha de la pantalla podemos acceder al menú de creación de nuevos posts. 

Los posts son descargados, subidos y actualizados en el backend de Firebase.

ANALYTICS
---------------------------------------------

He incluido analíticas en MainTimeLine para estadísticas de usuarios que entran en la app para ver posts como "Users" y en AuthorPostList para estadísticas de usuarios que escriben posts como "Authors".

También he incluido a modo de ejemplo el envío de eventos con las valoraciones por si nos sirven a modo estadístico. 

NOTAS SOBRE LA IMPLEMENTACIÓN
---------------------------------------------

He seleccionado la estrategia de usar en Firebase Database otra ruta para los **post publicados** donde se duplican estos por dos razones. Por un lado, no me fio mucho de que funcione después de que la ordenación no me funcione viendo que son métodos muy parecidos y he optado por esta opción para poder seguir avanzando y al final si tengo un poco de timpo lo revisaré. Por otro lado, porque así nos permite tratarlos a todos de manera global, por ejemplo, para observar cambios solo en los publicados si nos interesa, etc.  

El ultimo día he tenido problemas para usar los botones de **slide para BORRAR y PUBLICAR**. Aparecen pero no del todo al desplazar el ratón o se ocultan antes de poder pulsarlos. Funcionaban correctamente hasta el último día, pero no he podido comprobar si lo siguen haciendo tras hacer algunos cambios en el código el último día y como además he tenido que habilitar el pago por uso en Firebase porque he completado el máximo permitido en Storage con tanto subir y bajar imágenes no puedo probar mucho más.

La **actualización de posts** en la zona pública se hace de manera continua detectando cambios en servidor e actualizando nuevos posts publicados y posts borrados. Si bien el enunciado de la práctica indica que se haga al menos una vez al día en lugar de hacerlo de forma simultánea para ahorrar tráfico de datos, como no sé como programar esta función en Firebase no lo he implementado así. En ese caso, en lugar de usar "root.observe()" usaríamos "root.observeSingleEvent(of:)". 

El código implementado incluye la **ordenación de la tabla de posts** por fecha usando "root.queryOrdered(byChild: "Date")", usando como criterio de ordenación la fecha de creación del post que se guarda en su diccionario también, pero no he conseguido que me funcione la ordenación, ni por ese ni por otro criterio y por más documentación que he consultado no veo el error en el código. 

Finalmente, no me ha dado tiempo a incluir las Push Notifications. Prefiero verlas con tranquilidad que hacerlo sin prisas después de los problemas con los vídeos.


Para alguien que no ha programado nunca antes del bootcamp la verdad es que me ha servido para aprender mucho de backends y profundizar más en iOS.
 








  


