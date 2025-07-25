/**********************************************************************
 * Script Name   : uas.sql
 * Description   : Script project Ujian Akhir Semester
 * Author        : Fahad Vidjar Apriza
 * Created Date  : 25-07-2025
 * Last Modified : 25-07-2025
 **********************************************************************/


-- Buat database & gunakan database
create database BANK;
use BANK

-- Buat tabel Cabang
create table Cabang (
    kode_cabang varchar(20) primary key,
    nama_cabang varchar(100),
    alamat text
);

-- Buat tabel Jenis Tabungan
create table Jenis_Tabungan (
    kode_tabungan varchar(20) primary key,
    jeni_tabungan varchar(50)
);

-- Buat tabel Nasabah
create table Nasabah (
    kode_tabungan varchar(50),
    no_rekening varchar(20) primary key,
    nama varchar(100),
    alamat text,
    saldo bigint,
    foreign key (kode_tabungan) references Jenis_Tabungan(kode_tabungan)
);

-- Buat tabel Header Transaksi
create table Header_Transaksi (
    no_transaksi varchar(20) primary key,
    tgl_transaksi date,
    kode_cabang varchar(20),
    foreign key (kode_cabang) references Cabang(kode_cabang)
);

-- Buat tabel Detail Transaksi
create table Detail_Transaksi (
    id int identity(1,1) primary key,
    no_transaksi varchar(20),
    no_rekening varchar(20),
    jenis_transaksi char(1) check (jenis_transaksi in ("S", "T")),
    jml_transaksi bigint,
    foreign key (no_transaksi) references Header_Transaksi(no_transaksi),
    foreign key (no_rekening) references Nasabah(no_rekening)
);
go

-- ====================================================================================== --

-- Input data ke tabel Cabang
insert into Cabang values
    ('CBNI-0001', 'BNI Abdul Muis', 'Jln Jendral Achmad Yani No 123'),
    ('CBNI-0002', 'BNI Cempaka Mas', 'Jln Perintis Kemerdekaan No 117'),
    ('CBNI-0003', 'BNI Abdul Muis', 'Jln Cikini Raya Kav. 1-4 No 234')

-- Input data ke tabel Jenis_Tabungan
insert into Jenis_Tabungan values
    ('TBNI-001', 'BNI Taplus'),
    ('TBNI-002', 'BNI Taplus Bisnis'),
    ('TBNI-003', 'BNI Haji');

-- Input data ke tabel Nasabah
insert into Nasabah values
    ('TBNI-001', '000000-01', 'Dewi Sartika', 'Jakarta Selatan', 500000),
    ('TBNI-002', '000000-02', 'Kemal Ardian', 'Jakarta Pusat', 1000000),
    ('TBNI-003', '000000-03', 'Nuramalia', 'Jakarta Barat', 5000000);

-- Input data ke tabel Header_Transaksi
insert into Header_Transaksi values
    ('0000000001', '2025-07-12', 'CBNI-0001'),
    ('0000000002', '2025-07-17', 'CBNI-0002'),
    ('0000000003', '2025-07-21', 'CBNI-0003');

-- Input data ke tabel Detail_Transaksi
insert into Detail_Transaksi values
    ('0000000001', '000000-01', 'S', 500.000),
    ('0000000002', '000000-02', 'S', 1000000),
    ('0000000003', '000000-03', 'S', 5000000);