--desafio_3_Agustin_Guzman_168

--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.

	CREATE TABLE Usuarios (
    id serial PRIMARY KEY,
    email VARCHAR(100),
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    rol VARCHAR(20)
);

INSERT INTO Usuarios (email, nombre, apellido, rol)
VALUES
    ('usuario1@ejemplo.com', 'Juan', 'Doe', 'usuario'),
    ('usuario2@ejemplo.com', 'Marta', 'Smith', 'usuario'),
    ('admin@ejemplo.com', 'Miguel', 'Spencer', 'administrador'),
    ('usuario3@ejemplo.com', 'Alicia', 'Johnson', 'usuario'),
    ('usuario4@ejemplo.com', 'Roberto', 'Brown', 'usuario');

	CREATE TABLE Posts (
    id serial,
    titulo VARCHAR(100),
    contenido TEXT,
    fecha_creacion timestamp,
	fecha_actualizacion timestamp,
    destacado boolean,
	usuario_id bigint
);

INSERT INTO Posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_iD)
VALUES
    ('Titulo 1', 'Lorem Ipsum...Osaka', '2023-10-22 00:00:01','2023-10-22 00:00:02', TRUE, 3),
    ('Titulo 2', 'Lorem Ipsum...Tokyo', '2023-10-22 00:00:02','2023-10-22 00:00:03', FALSE, 3),
    ('Titulo 3', 'Lorem Ipsum...Nagoya', '2023-10-22 00:00:03','2023-10-22 00:00:04', TRUE, 1),
    ('Titulo 4', 'Lorem Ipsum...Kyoto', '2023-10-22 00:00:04','2023-10-22 00:00:05', FALSE, 2),
    ('Titulo 5', 'Lorem Ipsum...Nara', '2023-10-22 00:00:05','2023-10-22 00:00:06', TRUE, NULL);

	CREATE TABLE Comentarios (
	id serial,
    contenido TEXT,
    fecha_creacion timestamp,
	usuario_id bigint,
	post_id bigint
);

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_iD, post_id)
VALUES
    ('Lorem Ipsum...hola', '2023-10-22 00:00:05', 1, 1),
    ('Lorem Ipsum...chao', '2023-10-22 00:00:06', 2, 1),
    ('Lorem Ipsum...adiós', '2023-10-22 00:00:07', 3, 1),
    ('Lorem Ipsum...buongiorno', '2023-10-22 00:00:08', 1, 2),
    ('Lorem Ipsum...ohayo', '2023-10-22 00:00:09', 2, 2);

--2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.
	
SELECT Usuarios.nombre, Usuarios.email, Posts.titulo, Posts.contenido
FROM Usuarios 
INNER JOIN Posts 
ON Usuarios.id = Posts.usuario_id;	

--3. Muestra el id, título y contenido de los posts de los administradores. a. El administrador puede ser cualquier id.

SELECT Usuarios.id, Posts.titulo, Posts.contenido
FROM Usuarios
INNER JOIN Posts 
ON Usuarios.id = Posts.usuario_id
WHERE Usuarios.rol = 'administrador';

--4. Cuenta la cantidad de posts de cada usuario. a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

SELECT Usuarios.id, Usuarios.email, COUNT(Posts.id) AS cantidad_de_posts
FROM Usuarios
LEFT JOIN Posts 
ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id;

--5. Muestra el email del usuario que ha creado más posts. a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT Usuarios.email
FROM Usuarios
RIGHT JOIN (
    SELECT Posts.usuario_id, COUNT(Posts.id) AS cantidad_de_posts
    FROM Posts 
    GROUP BY Posts.usuario_id
    ORDER BY cantidad_de_posts DESC
    LIMIT 1
) AS Posts_de_los_Usuarios 
ON Usuarios.id = Posts_de_los_Usuarios.usuario_id;

--6. Muestra la fecha del último post de cada usuario

SELECT Usuarios.id, Usuarios.nombre, Usuarios.apellido, MAX(Posts.fecha_creacion) AS fecha_ultimo_post
FROM Usuarios
JOIN Posts
ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id;

--7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT Posts.titulo, Posts.contenido
FROM Posts
RIGHT JOIN (
    SELECT Comentarios.post_id
    FROM Comentarios 
    GROUP BY Comentarios.post_id
    ORDER BY COUNT(Comentarios.id) DESC
    LIMIT 1
) AS Post_Comments ON Posts.id = Post_Comments.post_id;

--8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió

SELECT Posts.titulo AS "Title", Posts.contenido AS "Content",
       Comentarios.contenido AS "Comment_Content", Usuarios.email AS "Email_Usuario"
FROM Posts
LEFT JOIN Comentarios
ON Posts.id = Comentarios.post_id
LEFT JOIN Usuarios
ON Comentarios.usuario_id = Usuarios.id;

--9. Muestra el contenido del último comentario de cada usuario.

SELECT Usuarios.email AS "Email_Usuario", Comentarios.contenido AS "Contenido_Comentario"
FROM Usuarios 
LEFT JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
WHERE Comentarios.fecha_creacion = (
    SELECT MAX(fecha_creacion)
    FROM Comentarios
    WHERE usuario_id = Usuarios.id
);

--10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Comentarios
ON Usuarios.id = Comentarios.usuario_id
GROUP BY Usuarios.email
HAVING COUNT(Comentarios.id) = 0;
