--
-- Name: create_account(character varying, uuid); Type: FUNCTION; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE FUNCTION opensociocracy_api.create_account(name_in character varying, owner_uid uuid) RETURNS TABLE(id bigint, uid uuid, created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$

DECLARE new_account_id BIGINT;
DECLARE new_account_uid uuid;
DECLARE new_account_created_at timestamp without time zone;

BEGIN
    
	INSERT INTO opensociocracy_api.account(name, personal)
		 VALUES(name_in, false)
		 RETURNING opensociocracy_api.account.id, opensociocracy_api.account.uid, opensociocracy_api.account.created_at INTO new_account_id, new_account_uid, new_account_created_at;
		
	INSERT INTO opensociocracy_api.account_member(account_id, member_id , roles)
		 VALUES(new_account_id, (SELECT m.id FROM opensociocracy_api.member m where m.uid = owner_uid),  '{"owner"}');

	RETURN QUERY SELECT new_account_id, new_account_uid, new_account_created_at;
	
	
END; 
$$;


ALTER FUNCTION opensociocracy_api.create_account(name_in character varying, owner_uid uuid) OWNER TO opensociocracy_api;

--
-- Name: create_account_nugget(character varying, character varying, character varying, bigint, uuid); Type: FUNCTION; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE FUNCTION opensociocracy_api.create_account_nugget(public_title character varying, internal_name character varying, nugget_type character varying, account_uid bigint, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $_$
#variable_conflict use_column
BEGIN

	INSERT INTO opensociocracy_api.nugget(
				public_title, 
				internal_name,   
				account_id, 
				nugget_type_id,
				created_at
			)
			VALUES (
				$1, 
				$2, 
				opensociocracy_api.get_member_account($4),
				1,
				DEFAULT
				)
 	RETURNING id, uid, created_at, account_id INTO id, uid, created_at, account_id;

	

	
END; 
$_$;


ALTER FUNCTION opensociocracy_api.create_account_nugget(public_title character varying, internal_name character varying, nugget_type character varying, account_uid bigint, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) OWNER TO opensociocracy_api;


--
-- Name: create_member_nugget(character varying, character varying, character varying, uuid, jsonb); Type: FUNCTION; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE FUNCTION opensociocracy_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, blocks jsonb, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $_$
#variable_conflict use_column
BEGIN

	INSERT INTO opensociocracy_api.nugget(
				public_title, 
				internal_name, 
				nugget_type,
				account_id,
				blocks
				)
			VALUES (
				$1, 
				$2, 
				$3,
				opensociocracy_api.get_member_account($4),
				$5
				)
 	RETURNING id, uid, created_at, account_id INTO id, uid, created_at, account_id;

	

	
END; 
$_$;


ALTER FUNCTION opensociocracy_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, blocks jsonb, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) OWNER TO opensociocracy_api;

--
-- Name: get_member_account(uuid); Type: FUNCTION; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE FUNCTION opensociocracy_api.get_member_account(uid_in uuid) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	RETURN (SELECT a.id 
	FROM opensociocracy_api.account_member am 
	INNER JOIN opensociocracy_api.account a ON a.id = am.account_id
	INNER JOIN opensociocracy_api.member m ON m.id = am.member_id
	WHERE m.uid = uid_in
	 AND a.personal = true
	ORDER BY a.created_at LIMIT 1);

	
END; 
$$;


ALTER FUNCTION opensociocracy_api.get_member_account(uid_in uuid) OWNER TO opensociocracy_api;

--
-- Name: get_member_accounts(uuid); Type: FUNCTION; Schema: opensociocracy_api; Owner: postgres
--

CREATE FUNCTION opensociocracy_api.get_member_accounts(uid_in uuid) RETURNS TABLE("accountUid" uuid, "createdAt" timestamp without time zone, name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	RETURN QUERY (SELECT a.uid, a.created_at, a.name 
	FROM opensociocracy_api.account_member am 
	INNER JOIN opensociocracy_api.account a ON a.id = am.account_id
	INNER JOIN opensociocracy_api.member m ON m.id = am.member_id
	WHERE m.uid = uid_in);

	
END; 
$$;


ALTER FUNCTION opensociocracy_api.get_member_accounts(uid_in uuid) OWNER TO opensociocracy_api;

--
-- Name: get_member_nuggets_by_type(uuid, text); Type: FUNCTION; Schema: opensociocracy_api; Owner: postgres
--

CREATE FUNCTION opensociocracy_api.get_member_nuggets_by_type(member_uid_in uuid, nugget_type_in text) RETURNS TABLE("nuggetUid" uuid, "createdAt" timestamp without time zone, "updatedAt" timestamp without time zone, "pubAt" timestamp without time zone, "unPubAt" timestamp without time zone, "publicTitle" character varying, "internalName" character varying, "nuggetType" character varying, blocks jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY 
SELECT 
n.uid AS "nuggetUid",  
n.created_at AS "createdAt",  
n.updated_at AS "updatedAt",  
n.pub_at AS "pubAt", 
n.un_pub_at AS "unPubAt", 
n.public_title AS "publicTitle", 
n.internal_name AS "internalName", 
n.nugget_type AS "nuggetType",
n.blocks
FROM opensociocracy_api.member m 
INNER JOIN opensociocracy_api.account_member am ON am.member_id = m.id
INNER JOIN opensociocracy_api.account a ON a.id = am.account_id
	AND a.personal = true
INNER JOIN opensociocracy_api.nugget n ON n.account_id = am.account_id
WHERE m.uid = member_uid_in
AND n.nugget_type = nugget_type_in;
END;
$$;


ALTER FUNCTION opensociocracy_api.get_member_nuggets_by_type(member_uid_in uuid, nugget_type_in text) OWNER TO opensociocracy_api;

--
-- Name: get_nugget_type_id(character varying, bigint); Type: FUNCTION; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE FUNCTION opensociocracy_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN (
  	SELECT id FROM opensociocracy_api.nugget_type WHERE name = 'article' AND ( account_id = account_id_in OR account_id IS NULL )
	ORDER BY account_id
	LIMIT 1
  );
  
	
END; 
$$;


ALTER FUNCTION opensociocracy_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint) OWNER TO opensociocracy_api;

--
-- Name: new_member_from_user(); Type: FUNCTION; Schema: opensociocracy_api; Owner: postgres
--

CREATE FUNCTION opensociocracy_api.new_member_from_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE new_member_id BIGINT;
	DECLARE new_account_id BIGINT;	
    DECLARE new_premium_account_id BIGINT;	
BEGIN

	INSERT INTO opensociocracy_api.member(uid, created_at)
	 VALUES(uuid(NEW.user_id), to_timestamp(NEW.time_joined/1000) )
	 RETURNING id INTO new_member_id;
	
	INSERT INTO opensociocracy_api.account(name)
		 VALUES('Member Account for ' || new_member_id )
		 RETURNING id INTO new_account_id;
		
	INSERT INTO opensociocracy_api.account_member(account_id, member_id, roles)
		 VALUES(new_account_id, new_member_id, '{"owner"}');

    INSERT INTO opensociocracy_api.account(name, personal)
		 VALUES('Premium Account for ' || new_member_id , false)
		 RETURNING id INTO new_premium_account_id;
		
	INSERT INTO opensociocracy_api.account_member(account_id, member_id, roles)
		 VALUES(new_premium_account_id, new_member_id, '{"owner"}');
		 
		 RETURN NEW;

END;
$$;


ALTER FUNCTION opensociocracy_api.new_member_from_user() OWNER TO opensociocracy_api;

--
-- Name: register_member(text, text, numeric); Type: FUNCTION; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE FUNCTION opensociocracy_api.register_member(uid_in text, email_in text, time_joined_in numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    
	INSERT INTO opensociocracy_api.member(uid, email, created_at, last_sign_in)
	VALUES(uuid(uid_in), email_in,  to_timestamp(time_joined_in/1000), CURRENT_TIMESTAMP)
	ON CONFLICT (uid) DO UPDATE 
	SET last_sign_in = CURRENT_TIMESTAMP, email = EXCLUDED.email;
	
	RETURN 'OK';
	
END; 
$$;


ALTER FUNCTION opensociocracy_api.register_member(uid_in text, email_in text, time_joined_in numeric) OWNER TO opensociocracy_api;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.account (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(150),
    personal boolean DEFAULT true
);


ALTER TABLE opensociocracy_api.account OWNER TO opensociocracy_api;

--
-- Name: account_group; Type: TABLE; Schema: opensociocracy_api; Owner: postgres
--

CREATE TABLE opensociocracy_api.account_group (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(64),
    roles text[]
);


ALTER TABLE opensociocracy_api.account_group OWNER TO opensociocracy_api;

--
-- Name: account_group_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: postgres
--

CREATE SEQUENCE opensociocracy_api.account_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.account_group_id_seq OWNER TO opensociocracy_api;

--
-- Name: account_group_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: postgres
--

ALTER SEQUENCE opensociocracy_api.account_group_id_seq OWNED BY opensociocracy_api.account_group.id;


--
-- Name: account_group_member; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.account_group_member (
    account_group_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE opensociocracy_api.account_group_member OWNER TO opensociocracy_api;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.account_id_seq OWNER TO opensociocracy_api;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.account_id_seq OWNED BY opensociocracy_api.account.id;


--
-- Name: account_member; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.account_member (
    account_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    roles text[] NOT NULL
);


ALTER TABLE opensociocracy_api.account_member OWNER TO opensociocracy_api;

--
-- Name: account_nugget_type; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.account_nugget_type (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE opensociocracy_api.account_nugget_type OWNER TO opensociocracy_api;

--
-- Name: account_role; Type: TABLE; Schema: opensociocracy_api; Owner: postgres
--

CREATE TABLE opensociocracy_api.account_role (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(24) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    account_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE opensociocracy_api.account_role OWNER TO opensociocracy_api;

--
-- Name: account_role_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: postgres
--

CREATE SEQUENCE opensociocracy_api.account_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.account_role_id_seq OWNER TO opensociocracy_api;

--
-- Name: account_role_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: postgres
--

ALTER SEQUENCE opensociocracy_api.account_role_id_seq OWNED BY opensociocracy_api.account_role.id;


--
-- Name: role; Type: TABLE; Schema: opensociocracy_api; Owner: postgres
--

CREATE TABLE opensociocracy_api.role (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(24) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE opensociocracy_api.role OWNER TO opensociocracy_api;

--
-- Name: all_perms; Type: VIEW; Schema: opensociocracy_api; Owner: postgres
--

CREATE VIEW opensociocracy_api.all_perms AS
 SELECT a.name,
    jsonb_object_agg(jsonb_each.key, jsonb_each.value) AS jsonb_object_agg
   FROM (( SELECT a_1.id,
            r.name,
            r.permissions
           FROM ((opensociocracy_api.account a_1
             JOIN opensociocracy_api.account_member am ON ((am.account_id = a_1.id)))
             JOIN opensociocracy_api.role r ON (((r.name)::text = ANY (am.roles))))
        UNION ALL
         SELECT a_1.id,
            ar.name,
            ar.permissions
           FROM (opensociocracy_api.account a_1
             JOIN opensociocracy_api.account_role ar ON ((ar.account_id = a_1.id)))) a
     CROSS JOIN LATERAL jsonb_each(a.permissions) jsonb_each(key, value))
  GROUP BY a.id, a.name;


ALTER TABLE opensociocracy_api.all_perms OWNER TO opensociocracy_api;

--
-- Name: block_type; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.block_type (
    id bigint NOT NULL,
    name character varying(150),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE opensociocracy_api.block_type OWNER TO opensociocracy_api;

--
-- Name: block_types_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.block_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.block_types_id_seq OWNER TO opensociocracy_api;

--
-- Name: block_types_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.block_types_id_seq OWNED BY opensociocracy_api.block_type.id;


--
-- Name: member; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.member (
    id bigint NOT NULL,
    uid uuid,
    created_at timestamp without time zone
);


ALTER TABLE opensociocracy_api.member OWNER TO opensociocracy_api;

--
-- Name: member_accounts; Type: VIEW; Schema: opensociocracy_api; Owner: postgres
--

CREATE VIEW opensociocracy_api.member_accounts AS
 SELECT m.id AS "memberId",
    m.uid AS "memberUid",
    m.created_at AS "memberCreatedAt",
    a.id AS "accountId",
    a.uid AS "accountUid",
    a.personal AS "personalAccount",
    a.created_at AS "accountCreatedAt",
    a.name AS "accountName",
    am.roles AS "accountRoles",
    ag.name AS "groupName",
    ag.roles AS "groupRoles",
    agm.created_at AS "groupMembershipCreatedAt"
   FROM ((((opensociocracy_api.member m
     JOIN opensociocracy_api.account_member am ON ((am.member_id = m.id)))
     JOIN opensociocracy_api.account a ON ((a.id = am.account_id)))
     LEFT JOIN opensociocracy_api.account_group_member agm ON ((agm.member_id = m.id)))
     LEFT JOIN opensociocracy_api.account_group ag ON ((ag.id = agm.account_group_id)));


ALTER TABLE opensociocracy_api.member_accounts OWNER TO opensociocracy_api;

--
-- Name: member_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.member_id_seq OWNER TO opensociocracy_api;

--
-- Name: member_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.member_id_seq OWNED BY opensociocracy_api.member.id;


--
-- Name: member_permissions; Type: VIEW; Schema: opensociocracy_api; Owner: postgres
--

CREATE VIEW opensociocracy_api.member_permissions AS
 SELECT ma."memberUid",
    ma."accountUid",
    r.name AS "roleName",
    r.permissions
   FROM (opensociocracy_api.member_accounts ma
     JOIN opensociocracy_api.role r ON (((r.name)::text = ANY (ma."accountRoles"))));


ALTER TABLE opensociocracy_api.member_permissions OWNER TO opensociocracy_api;

--
-- Name: nugget; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.nugget (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    pub_at timestamp without time zone,
    un_pub_at timestamp without time zone,
    public_title character varying(150),
    internal_name character varying(75),
    account_id bigint NOT NULL,
    blocks jsonb DEFAULT '{}'::jsonb,
    nugget_type character varying(64) NOT NULL
);


ALTER TABLE opensociocracy_api.nugget OWNER TO opensociocracy_api;

--
-- Name: nugget_comment; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.nugget_comment (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    "created_at " timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);


ALTER TABLE opensociocracy_api.nugget_comment OWNER TO opensociocracy_api;

--
-- Name: nugget_comment_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.nugget_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.nugget_comment_id_seq OWNER TO opensociocracy_api;

--
-- Name: nugget_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.nugget_comment_id_seq OWNED BY opensociocracy_api.nugget_comment.id;


--
-- Name: nugget_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.nugget_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.nugget_id_seq OWNER TO opensociocracy_api;

--
-- Name: nugget_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.nugget_id_seq OWNED BY opensociocracy_api.nugget.id;


--
-- Name: nugget_member; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.nugget_member (
    nugget_id bigint NOT NULL,
    member_id bigint NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE opensociocracy_api.nugget_member OWNER TO opensociocracy_api;

--
-- Name: nugget_reaction; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.nugget_reaction (
    nugget_id bigint NOT NULL,
    account_id bigint NOT NULL,
    member_id bigint NOT NULL
);


ALTER TABLE opensociocracy_api.nugget_reaction OWNER TO opensociocracy_api;

--
-- Name: nugget_type; Type: TABLE; Schema: opensociocracy_api; Owner: postgres
--

CREATE TABLE opensociocracy_api.nugget_type (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE opensociocracy_api.nugget_type OWNER TO opensociocracy_api;



--
-- Name: response; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.response (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    comment_id bigint,
    response_id bigint,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);


ALTER TABLE opensociocracy_api.response OWNER TO opensociocracy_api;

--
-- Name: response_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.response_id_seq OWNER TO opensociocracy_api;

--
-- Name: response_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.response_id_seq OWNED BY opensociocracy_api.response.id;


--
-- Name: service; Type: TABLE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE TABLE opensociocracy_api.service (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_required character varying(10) DEFAULT 'member'::character varying NOT NULL
);


ALTER TABLE opensociocracy_api.service OWNER TO opensociocracy_api;

--
-- Name: service_id_seq; Type: SEQUENCE; Schema: opensociocracy_api; Owner: opensociocracy_api
--

CREATE SEQUENCE opensociocracy_api.service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opensociocracy_api.service_id_seq OWNER TO opensociocracy_api;

--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER SEQUENCE opensociocracy_api.service_id_seq OWNED BY opensociocracy_api.service.id;


--
-- Name: account id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.account ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.account_id_seq'::regclass);


--
-- Name: account_group id; Type: DEFAULT; Schema: opensociocracy_api; Owner: postgres
--

ALTER TABLE ONLY opensociocracy_api.account_group ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.account_group_id_seq'::regclass);


--
-- Name: account_role id; Type: DEFAULT; Schema: opensociocracy_api; Owner: postgres
--

ALTER TABLE ONLY opensociocracy_api.account_role ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.account_role_id_seq'::regclass);


--
-- Name: block_type id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.block_type ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.block_types_id_seq'::regclass);


--
-- Name: member id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.member ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.member_id_seq'::regclass);


--
-- Name: nugget id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.nugget ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.nugget_id_seq'::regclass);


--
-- Name: nugget_comment id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.nugget_comment ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.nugget_comment_id_seq'::regclass);


--
-- Name: response id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.response ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.response_id_seq'::regclass);


--
-- Name: service id; Type: DEFAULT; Schema: opensociocracy_api; Owner: opensociocracy_api
--

ALTER TABLE ONLY opensociocracy_api.service ALTER COLUMN id SET DEFAULT nextval('opensociocracy_api.service_id_seq'::regclass);
