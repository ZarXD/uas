

create table Cabang (
    kode_cabang varchar(20) primary key,
    nama_cabang varchar(100),
    alamat text
);

create table Jenis_Tabungan (
    kode_tabungan varchar(20) primary key,
    jeni_tabungan varchar(50)
);

create table Nasabah (
    no_rekening varchar(20) primary key,
    kode_tabungan varchar(50),
    nama varchar(100),
    alamat text,
    saldo bigint,
    foreign key (kode_tabungan) references Jenis_Tabungan(kode_tabungan)
);

create table Header_Transaksi (
    no_transaksi varchar(20) primary key,
    tgl_transaksi date,
    kode_cabang varchar(20),
    foreign key (kode_cabang) references Cabang(kode_cabang)
);

create table Detail_Transaksi (
    id int identity(1,1) primary key,
    no_transaksi varchar(20),
    no_rekening varchar(20),
    jenis_transaksi char(1) check (jenis_transaksi in ("S", "T")),
    jml_transaksi bigint,
    foreign key (no_transaksi) references Header_Transaksi(no_transaksi),
    foreign key (no_rekening) references Nasabah(no_rekening)
);