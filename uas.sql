/**********************************************************************
 * Script Name   : uas.sql
 * Description   : Script project Ujian Akhir Semester
 * Author        : Fahad Vidjar Apriza
 * Created Date  : 25-07-2025
 * Last Modified : 26-07-2025
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
go

-- ====================================================================================== --

-- Tampilkan semua data Nasabah
select * from Nasabah;

-- Tampilkan data dari tabel Nasabah dan Jenis_Tabungan dengan INNER JOIN
select
    n.no_rekening,
    n.nama,
    n.alamat,
    n.saldo,
    jt.kode_tabungan,
    jt.jenis_tabungan
from 
    Nasabah n
inner join
    Jenis_Tabungan jt on n.kode_tabungan = jt.kode_tabungan;
go

-- View gabungan 4 tabel : View_Transaksi
create view Veiw_Transaksi as
    select
        d.id as id_detail,
        ht.no_transaksi,
        ht.tgl_transaksi,
        ht.kode_cabang,
        c.nama_cabang,
        c.alamat as alamat_cabang,
        d.no_rekening,
        n.nama as nama_nasabah,
        n.alamat as alamat_nasabah,
        n.saldo,
        d.jenis_transaksi,
        d.jml_transaksi
    from
        Detail_Transaksi d
    inner join
        Header_Transaksi ht on d.no_transaksi = ht.no_transaksi
    inner join
        Nasabah n on d.no_rekening = n.no_rekening
    inner join
        Cabang c on ht.kode_cabang = c.kode_cabang;
go

-- Tampilkan data dari View_Transaksi dengan saldo < 500.000
select * from View_Transaksi
where saldo < 500000;
go

-- Tampilkan data dari View_Transaksi dengan saldo > 500.000
select * from View_Transaksi
where saldo > 500000;
go

-- Tampilkan data dari View_Transaksi dengan saldo > 500.000 dan nama nasabah berawalan "N"
select * from View_Transaksi
where saldo > 500000
    and nama_nasabah like 'N%';
go

-- Grouping berdasakan nomor transaksi dari View_Transaksi
select
    no_transaksi,
    count(*) as jumlah_detail,
    sum(jml_transaksi) as total_transaksi,
    max(saldo) as saldo_tertinggi,
    min(saldo) as saldo_terendah
from
    View_Transaksi
group by
    no_transaksi;
go

-- ====================================================================================== --

-- WIP hari ini coyyy harus beres🚀🚀🚀

-- 14. Stored Procedure : Menampilkan semua data Nasabah
-- 15. Stored Procedure : Tampilkan data Nasabah berdasarkan No Rekening
-- 16. Stored Procedure : Tambah 10 data Nasabah
-- 17. Stored Procedure : Ubah data Nasabah
-- 18. Stored Procedure : Hapus data Nasabah
-- 19. Tampilkan total saldo seluruh Nasabah
-- 20. Hapus 1 record Header dan Detail Transaksi berdasarkan No Transaksi
-- 21. Trigger untuk INSERT ke Detail_Transaksi -> Update saldo Nasabah
-- 22. Stored Procedure : Menambah data ke tabel Header_Transaksi
-- 23. Stored Procedure : Menambah data ke tabel Detail_Transaksi
-- 24. Eksekusi Stored Procedure tambah transaksi baru (otomatis trigger jalan)
-- 25. Gunakan COMMIT atau ROLLBACK setelah menambah data