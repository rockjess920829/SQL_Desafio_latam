--Creando la base de datos
create database desafio3_Jessica_Campo;

--Conectando a la base de datos
\c desafio3_Jessica_Campo;

--Creando la tabla usuarios
create table usuarios (id serial,email varchar, nombre text, apellido text, rol varchar);

--Verificar tabla usuarios
select * from usuarios;

--Insertando datos a tabla usuarios
insert into usuarios(id,email, nombre, apellido, rol) values (1, 'mono@gmail.com', 'mono', 'araña', 'administrador');
insert into usuarios(id,email, nombre, apellido, rol) values (2, 'sandrofilus@gmail.com', 'sandri', 'craz', 'usuario');
insert into usuarios(id,email, nombre, apellido, rol) values (3, 'vagipower@gmail.com', 'vagi', 'power', 'usuario');
insert into usuarios(id,email, nombre, apellido, rol) values (4, 'espanto@gmail.com', 'erik', 'lopez', 'usuario');
insert into usuarios(id,email, nombre, apellido, rol) values (5, 'vistima@gmail.com', 'pau', 'osorno', 'usuario');

--Verificar inserciones de datos a la tabla usuarios
select * from usuarios;

--Creando la tabla post o articulos
create table post (id serial, titulo varchar, contenido text, fecha_creacion timestamp, fecha_actualizacion timestamp, destacado boolean, usuario_id bigint);

--Verificar tabla post
select * from post;

--Insertando datos a tabla post
--post_id 1 al adm
insert into post
	(id,titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
	values (1, 'control','controlar publicaciones por adm', '2023-10-22 00:00:00', '2023-10-22 00:00:00',true, 1);
--post_id 2 al adm
insert into post
	(id,titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
	values (2, 'publicar','contenido minimo de publicaciones', '2023-10-21 00:00:00', '2023-10-21 00:00:00',true, 1);
--post 3 al usuario (3, 4 o 5)
insert into post
	(id,titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
	values (3, 'micro ambiental','Los derrames de petroleo pueden biorremediarse ', '2023-10-22 00:00:00', '2023-10-22 00:00:00',false, 3);
--post 4 al usuario (3, 4 o 5)
insert into post
	(id,titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
	values (4, 'micro industrial','La economia circular incluye a las biorrefinerias', '2023-10-22 00:00:00', '2023-10-22 00:00:00',true, 4);
--post 5 no tiene usuario_id  
insert into post
	(id,titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
	values (5, 'microbiologia','La microbiologia tiene muchas subareas', '2023-10-21 00:00:00', '2023-10-21 00:00:00',true, NULL);
--Verificar inserciones a la tabla post
select * from post;


--Creando la tabla comentarios
create table comentarios (id serial, contenido text, fecha_creacion timestamp, usuario_id bigint, post_id bigint);

--Verificar tabla comentarios
select * from comentarios;

--Insertando datos a tabla comentarios
--comentario id_1 asociado al post 1 usuario 1
insert into comentarios
	(id, contenido, fecha_creacion, usuario_id, post_id) 
	values (1, 'control del contenido','2023-10-22 00:00:00',1,1);
--comentario id_2 asociado al post 1 usuario 2
insert into comentarios
	(id, contenido, fecha_creacion, usuario_id, post_id) 
	values (2, 'publicaciones en la tarea','2023-10-21 00:00:00',2,1);
--comentario id_3 asociado al post 1 usuario 3
insert into comentarios
	(id, contenido, fecha_creacion, usuario_id, post_id) 
	values (3, 'numero de publicaciones para la nota','2023-10-22 00:00:00',3,1);
--comentario 4 asociado al post 2 usuario 1
insert into comentarios
	(id, contenido, fecha_creacion, usuario_id, post_id) 
	values (4, 'numero minimo de caracteres','2023-10-21 00:00:00',1,2);
--comentario 5 asociado al post 2 usuario 2
insert into comentarios
	(id, contenido, fecha_creacion, usuario_id, post_id) 
	values (5, 'numero de comentarios al compañero','2023-10-23 00:00:00',2,2);
--Verificar inserciones a la tabla comentarios
select * from comentarios;

--2. Cruce de datos de la tabla usuarios y post 
--columnas: nombre_usuario, email_usuario, titulo_post y contenido_post
select * from usuarios;
select * from post;

select u.nombre,u.email,p.titulo, p.contenido
	from usuarios as u
		inner join post as p
			on u.id=p.usuario_id;
			
--3. Muestra el id, título y contenido de los post de los administradores
select u.rol, p.titulo, p.contenido, p.usuario_id
	from post as p
		inner join usuarios as u
			on u.id=p.usuario_id
order by p.usuario_id limit 1;

--4. Cuenta la cantidad de post de cada usuario
--tabla debe tener id_usuario, email_usuario, conteo numero post por usuario: count(p.usuario_id)

select u.id, u.email, count(p.usuario_id) as numero_post
	from usuarios as u
		left join post as p
			on u.id=p.usuario_id
group by u.id, u.email order by u.id;

--5. Email_usuario con mayor número de post: count(p.usuario_id) as numero_post
--order by conteo_post desc limit 1
--Aquí la tabla resultante tiene un único registro y muestra solo el email.
select u.email, count(p.usuario_id) as numero_post
	from usuarios as u
		left join post as p
			on u.id=p.usuario_id
group by u.email order by numero_post desc limit 1;

--6. Muestra la fecha del ultimo post de cada usuario. 
--u.id, p.titulo, p.fecha_creacion

select p.usuario_id, p.fecha_creacion
	from post as p
		left join usuarios as u
			on u.id=p.usuario_id
group by p.usuario_id, p.fecha_creacion order by p.fecha_creacion desc;

--Punto 6 con el uso del max sobre fecha_creacion
select p.usuario_id, max(p.fecha_creacion) as max_fecha_creacion
	from post as p
		left join usuarios as u
			on u.id=p.usuario_id
group by p.usuario_id order by max_fecha_creacion desc;

--7. Muestra el título y contenido del post (artículo) 
--con más comentarios.

select p.titulo, p.contenido, count(c.post_id) as conteo_coment
	from comentarios as c
		right join post as p
			on p.id=c.post_id
group by p.titulo, p.contenido order by conteo_coment desc limit 1;

--8. Muestra en una tabla el título de cada post, 
--el contenido de cada post y 
--el contenido de cada comentario asociado a los posts mostrados
--junto con el email del usuario que lo escribió.

select p.titulo, p.contenido as cont_post, c.contenido as cont_coment, u.email
	from post as p
		full join comentarios as c
			on p.id=c.post_id
		full join usuarios as u
			on u.id=p.usuario_id;
			
--9. Muestra el contenido del último comentario de cada usuario.
select u.nombre,u.apellido, u.rol, u.id, c.contenido as cont_coment, c.fecha_creacion
	from post as p
		left join comentarios as c
			on p.id=c.post_id
		right join usuarios as u
			on u.id=p.usuario_id
order by c.fecha_creacion desc;

--9. sin registros NULL
select u.nombre,u.apellido, u.rol, u.id, c.contenido as cont_coment, c.fecha_creacion
	from post as p
		left join comentarios as c
			on p.id=c.post_id
		right join usuarios as u
			on u.id=p.usuario_id
where c.fecha_creacion is not NULL
order by c.fecha_creacion desc;

--10. Muestra los emails de los usuarios 
--que no han escrito ningún comentario.
select u.id, u.email,u.nombre,u.apellido,c.contenido as cont_coment
	from post as p
		left join comentarios as c
			on p.id=c.post_id
		right join usuarios as u
			on u.id=p.usuario_id
where c.contenido is NULL;



