/**********************************************************************
 * Script Name   : full_script.sql
 * Description   : Script project Ujian Akhir Semester
 * Author        : Fahad Vidjar Apriza
 * Created Date  : 25-07-2025
 * Last Modified : 27-07-2025
 **********************************************************************/


-- 4. Buat database & gunakan database
create database BANK;
use BANK

-- 5. Buat tabel yang telah di rancang --
-- Buat tabel Cabang
create table Cabang (
    kode_cabang varchar(20) primary key,
    nama_cabang varchar(100),
    alamat text
);

-- Buat tabel Jenis Tabungan
create table Jenis_Tabungan (
    kode_tabungan varchar(20) primary key,
    jenis_tabungan varchar(50)
);

-- Buat tabel Nasabah
create table Nasabah (
    no_rekening varchar(20) primary key,
    kode_tabungan varchar(50),
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

-- 6. Input data ke dalam tabel --
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
    ('000000-01', 'TBNI-001', 'Dewi Sartika', 'Jakarta Selatan', 500000),
    ('000000-02', 'TBNI-002', 'Kemal Ardian', 'Jakarta Pusat', 1000000),
    ('000000-03', 'TBNI-003', 'Nuramalia', 'Jakarta Barat', 5000000);

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

-- 7. Tampilkan semua data Nasabah
select * from Nasabah;

-- 8. Tampilkan data dari tabel Nasabah dan Jenis_Tabungan dengan INNER JOIN
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

-- 9. View gabungan 4 tabel : View_Transaksi
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

-- 10. Tampilkan data dari View_Transaksi dengan saldo < 500.000
select * from View_Transaksi
where saldo < 500000;
go

-- 11. Tampilkan data dari View_Transaksi dengan saldo > 500.000
select * from View_Transaksi
where saldo > 500000;
go

-- 12. Tampilkan data dari View_Transaksi dengan saldo > 500.000 dan nama nasabah berawalan "N"
select * from View_Transaksi
where saldo > 500000
    and nama_nasabah like 'N%';
go

-- 13. Grouping berdasakan nomor transaksi dari View_Transaksi
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

-- 14. Stored Procedure : Menampilkan semua data Nasabah
create proc Sp_TampilDataNasabah
as
    begin
        select * from Nasabah;
    end;
go

-- 15. Stored Procedure : Tampilkan data Nasabah berdasarkan No Rekening
create proc Sp_TampilNasabahByRekening
    @no_rekening varchar(20)
as
    begin
        select * from Nasabah where no_rekening = @no_rekening;
    end
go

-- 16. Stored Procedure : Tambah data Nasabah
create proc Sp_TambahNasabah
    @no_rekening varchar(20),
    @kode_tabungan varchar(50),
    @nama varchar(100),
    @alamat text,
    @saldo bigint
as
    begin
        -- Cek apakah no rekening sudah ad
        if exists (select 1 from Nasabah where no_rekening = @no_rekening)
        begin
            raiserror('Rekening sudah tedaftar', 16, 1);
            return;
        end

        -- Tambah nasabah baru
        insert into Nasabah (no_rekeninng, kode_tabungan, nama, alamat, saldo) values
            (@no_rekening, @kode_tabungan, @nama, @alamat, @saldo);

        print 'Nasabah berhasil ditambahkan';
    end;
go

-- 17. Stored Procedure : Ubah data Nasabah
create proc Sp_TambahNasabah
    @no_rekening varchar(20),
    @kode_tabungan varchar(50),
    @nama varchar(100),
    @alamat text,
    @saldo bigint
as
    begin
        -- Cek apakah no rekening sudah ad
        if not exists (select 1 from Nasabah where no_rekening = @no_rekening)
        begin
            raiserror('Rekening tidak ditemukan', 16, 1);
            return;
        end

        -- Update data nasabah
        update Nasabah
        set
            kode_tabungan = @kode_tabungan,
            nama = @nama,
            alamat = @alamat,
            saldo = @saldo
        where no_rekening = @no_rekening;

        print 'Data nasabah berhasil diperbarui';
    end;
go

-- 18. Stored Procedure : Hapus data Nasabah
create proc Sp_TambahNasabah
    @no_rekening varchar(20)
as
    begin
        -- Cek apakah no rekening sudah ad
        if not exists (select 1 from Nasabah where no_rekening = @no_rekening)
        begin
            raiserror('Rekening tidak ditemukan', 16, 1);
            return;
        end

        -- Hapus nasabah
        delete from Nasabah where no_rekening = @no_rekening
        
        print 'Data nasabah berhasil diperbarui';
    end;
go

-- 19. Tampilkan total saldo seluruh Nasabah
select sum(saldo) as total_saldo from Nasabah;
go

-- 20. Hapus 1 record Header dan Detail Transaksi berdasarkan No Transaksi
-- Metode Store Procedured
create proc Sp_HapusTransaksi
    @no_transaksi varchar(20)
as
    begin
        delete from Detail_Transaksi where no_transaksi = @no_transaksi
        delete from Header_Transaksi where no_transaksi = @no_transaksi
    end;
go

-- 21. Trigger untuk INSERT ke Detail_Transaksi -> Update saldo Nasabah
create trigger Tr_Transaksi
on Detail_Transaksi
after insert
as
    begin
        set nocount on;

        update n
        set n.saldo =
                case
                    when i.jenis_transaksi = 'S' then n.saldo + i.jml_transaksi
                    when i.jenis_transaksi = 'T' then n.saldo - i.jml_transaksi
                    else n.saldo
                end
        from Nasabah n
        inner join inserted i on n.no_rekening = i.no_rekening
    end;
go

-- 22. Stored Procedure : Menambah data ke tabel Header_Transaksi
create proc Sp_TambahHeaderTransaksi
    @no_transaksi varchar(20),
    @tgl_transaksi date,
    @kode_cabang varchar(20)
as
begin
    insert into Header_Transaksi (no_transaksi, tgl_transaksi, kode_cabang) values
        (@no_transaksi, @tgl_transaksi, @kode_cabang);
end;
go

-- 23. Stored Procedure : Menambah data ke tabel Detail_Transaksi
create proc Sp_TambahDetailTransaksi
    @no_transaksi varchar(20),
    @no_rekening varchar(20),
    @jenis_transaksi char(1),
    @jml_transaksi bigint
as
begin
    insert into Detail_Transaksi (no_transaksi, no_rekening, jenis_transaksi, jml_transaksi) values
    (@no_transaksi, @no_rekening, @jenis_transaksi, @jml_transaksi);
end;
go

-- 24. Eksekusi Stored Procedure tambah transaksi baru (otomatis trigger jalan)
exec Sp_TambahHeaderTransaksi '0000000005', '2025-07-24', 'CBNI-0001';
exec Sp_TambahDetailTransaksi '0000000005', '000000-01', 'S', 5000000;

exec Sp_TambahHeaderTransaksi '0000000006', '2025-07-25', 'CBNI-0001';
exec Sp_TambahDetailTransaksi '0000000006', '000000-01', 'T', 1000000;

-- 25. Gunakan COMMIT atau ROLLBACK setelah menambah data
-- Commit transaction
begin tran
    exec Sp_TambahHeaderTransaksi '0000000007', '2025-07-24', 'CBNI-0001';
    exec Sp_TambahDetailTransaksi '0000000007', '000000-02', 'S', 200000;
commit

begin tran
    exec Sp_TambahHeaderTransaksi '0000000007', '2025-07-24', 'CBNI-0001';
    exec Sp_TambahDetailTransaksi '0000000007', '000000-02', 'T', 99999999;
rollback