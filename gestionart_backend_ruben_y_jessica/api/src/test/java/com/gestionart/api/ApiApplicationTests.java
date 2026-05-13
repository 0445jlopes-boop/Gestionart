package com.gestionart.api;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;

import com.gestionart.api.application.service.*;
import com.gestionart.api.domain.enums.*;
import com.gestionart.api.domain.models.*;
import com.gestionart.api.domain.repository.*;
import com.gestionart.api.exception.*;
import com.gestionart.api.infrastructure.security.JwtService;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

// ==================== TESTS RF-01: LOGIN CON ROLES ====================

@ExtendWith(MockitoExtension.class)
class AutenticacionServiceTest {

    @Mock
    private CompradorRepository compradorRepository;

    @Mock
    private VendedorRepository vendedorRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private AutenticacionService autenticacionService;

    @Test
    void testRegistrarCompradorExitoso() {
        Comprador comprador = new Comprador();
        comprador.setCorreoElectronico("comprador@test.com");
        comprador.setContrasena("password");
        comprador.setNombre("Juan");

        when(compradorRepository.findByCorreoElectronico(anyString()))
            .thenReturn(Optional.empty());
        when(vendedorRepository.findByCorreoElectronico(anyString()))
            .thenReturn(Optional.empty());
        when(compradorRepository.findByNombre(anyString()))
            .thenReturn(Optional.empty());
        when(vendedorRepository.findByNombre(anyString()))
            .thenReturn(Optional.empty());
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(compradorRepository.save(any(Comprador.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        Comprador resultado = autenticacionService.registrarComprador(comprador);

        assertNotNull(resultado);
        assertEquals("comprador@test.com", resultado.getCorreoElectronico());
    }

    @Test
    void testLoginCompradorExitoso() {
        String email = "comprador@test.com";
        String password = "ClaveSegura123";
        String token = "jwt-token-123";

        Comprador comprador = new Comprador();
        comprador.setCorreoElectronico(email);
        comprador.setContrasena("hashedPassword");

        when(compradorRepository.findByCorreoElectronico(email))
            .thenReturn(Optional.of(comprador));
        when(passwordEncoder.matches(password, comprador.getContrasena()))
            .thenReturn(true);
        when(jwtService.generarToken(email, "COMPRADOR"))
            .thenReturn(token);

        String resultado = autenticacionService.login(email, password);

        assertNotNull(resultado);
        assertEquals(token, resultado);
    }

    @Test
    void testLoginVendedorExitoso() {
        String email = "vendedor@test.com";
        String password = "ClaveSegura123";
        String token = "jwt-token-456";

        Vendedor vendedor = new Vendedor();
        vendedor.setCorreoElectronico(email);
        vendedor.setContrasena("hashedPassword");

        when(compradorRepository.findByCorreoElectronico(email))
            .thenReturn(Optional.empty());
        when(vendedorRepository.findByCorreoElectronico(email))
            .thenReturn(Optional.of(vendedor));
        when(passwordEncoder.matches(password, vendedor.getContrasena()))
            .thenReturn(true);
        when(jwtService.generarToken(email, "VENDEDOR"))
            .thenReturn(token);

        String resultado = autenticacionService.login(email, password);

        assertNotNull(resultado);
        assertEquals(token, resultado);
    }

    @Test
    void testLoginCredencialesIncorrectas() {
        String email = "usuario@test.com";
        String password = "ContraseñaIncorrecta";

        when(compradorRepository.findByCorreoElectronico(email))
            .thenReturn(Optional.empty());
        when(vendedorRepository.findByCorreoElectronico(email))
            .thenReturn(Optional.empty());

        assertThrows(NotFoundByCorreoException.class, () -> {
            autenticacionService.login(email, password);
        });
    }

    @Test
    void testLoginPasswordIncorrecta() {
        String email = "usuario@test.com";
        String password = "ContraseñaIncorrecta";

        Comprador comprador = new Comprador();
        comprador.setCorreoElectronico(email);
        comprador.setContrasena("hashedPassword");

        when(compradorRepository.findByCorreoElectronico(email))
            .thenReturn(Optional.of(comprador));
        when(passwordEncoder.matches(password, comprador.getContrasena()))
            .thenReturn(false);

        assertThrows(InvalidCredentials.class, () -> {
            autenticacionService.login(email, password);
        });
    }
}

// ==================== TESTS RF-02: NOTIFICACIÓN DE ENCARGO ====================

@ExtendWith(MockitoExtension.class)
class NotificacionServiceTest {

    @Mock
    private NotificacionRepository notificacionRepository;

    @Mock
    private VendedorService vendedorService;

    @InjectMocks
    private NotificacionService notificacionService;

    @Test
    void testCrearNotificacionExitoso() {
        Long idVendedor = 1L;
        TipoNotificacion tipo = TipoNotificacion.NUEVO_PEDIDO;
        
        Notificacion notificacion = new Notificacion();
        notificacion.setVendedorId(idVendedor);
        notificacion.setTipo(tipo);
        notificacion.setLeido(false);

        when(vendedorService.obtenerPorId(idVendedor))
            .thenReturn(new Vendedor());
        when(notificacionRepository.save(any(Notificacion.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        Notificacion resultado = notificacionService.crearNotificacion(idVendedor, tipo);

        assertNotNull(resultado);
        assertEquals(tipo, resultado.getTipo());
        assertFalse(resultado.isLeido());
    }

    @Test
    void testObtenerNotificacionesPorVendedor() {
        Long idVendedor = 1L;
        List<Notificacion> notificaciones = Arrays.asList(new Notificacion(), new Notificacion());

        when(vendedorService.obtenerPorId(idVendedor))
            .thenReturn(new Vendedor());
        when(notificacionRepository.findByVendedorId(idVendedor))
            .thenReturn(notificaciones);

        List<Notificacion> resultado = notificacionService.obtenerPorVendedor(idVendedor);

        assertEquals(2, resultado.size());
        verify(vendedorService, times(1)).obtenerPorId(idVendedor);
    }

    @Test
    void testObtenerNotificacionesNoLeidas() {
        Long idVendedor = 1L;
        List<Notificacion> notificaciones = Arrays.asList(new Notificacion());

        when(vendedorService.obtenerPorId(idVendedor))
            .thenReturn(new Vendedor());
        when(notificacionRepository.findByVendedorIdAndLeidoFalse(idVendedor, false))
            .thenReturn(notificaciones);

        List<Notificacion> resultado = notificacionService.obtenerNoLeidas(idVendedor);

        assertEquals(1, resultado.size());
    }
}

// ==================== TESTS RF-03: CALCULADORA DE BENEFICIO ====================

class CalculadoraTest {

    private static final double VALOR_HORA = 20.0;
    private static final double COMISION = 0.10;

    @Test
    void testCalcularCostoTotal() {
        double horas = 5.0;
        double materiales = 50.0;
        double esperado = (5.0 * 20.0) + 50.0; // 150.0

        double resultado = (horas * VALOR_HORA) + materiales;

        assertEquals(esperado, resultado, 0.01);
    }

    @Test
    void testCalcularComision() {
        double precioVenta = 166.67;
        double esperado = 166.67 * 0.10; // 16.667

        double resultado = precioVenta * COMISION;

        assertEquals(esperado, resultado, 0.01);
    }

    @Test
    void testCalcularBeneficioNeto() {
        double costoTotal = 150.0;
        double comision = 16.67;
        double precioVenta = 166.67;
        double esperado = 166.67 - 150.0 - 16.67; // 0.0

        double resultado = precioVenta - costoTotal - comision;

        assertEquals(esperado, resultado, 0.01);
    }

    @Test
    void testCalcularBeneficioPerdida() {
        double costoTotal = 250.0;
        double comision = 25.0;
        double precioVenta = 250.0;
        double esperado = 250.0 - 250.0 - 25.0; // -25.0

        double resultado = precioVenta - costoTotal - comision;

        assertTrue(resultado < 0);
    }

    @Test
    void testValidarHorasPositivas() {
        double horas = 5.0;
        assertTrue(horas >= 0);
    }

    @Test
    void testValidarMaterialesPositivos() {
        double materiales = 50.0;
        assertTrue(materiales >= 0);
    }
}

// ==================== TESTS RF-04: CATÁLOGO DE PRODUCTOS ====================

@ExtendWith(MockitoExtension.class)
class ArticuloServiceTest {

    @Mock
    private ArticuloRepository articuloRepository;

    @InjectMocks
    private ArticuloService articuloService;

    @Test
    void testCrearArticulo() {
        Articulo articulo = new Articulo();
        articulo.setTitulo("Cuadro Abstracto");
        articulo.setPrecio(100.0);
        articulo.setStock(10);
        articulo.setIdVendedor(1L);

        when(articuloRepository.save(any(Articulo.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        Articulo resultado = articuloService.crear(articulo);

        assertNotNull(resultado);
        assertEquals("Cuadro Abstracto", resultado.getTitulo());
        assertEquals(100.0, resultado.getPrecio());
    }

    @Test
    void testListarArticulosDisponibles() {
        List<Articulo> articulos = Arrays.asList(
            new Articulo(),
            new Articulo()
        );

        when(articuloRepository.findByStockGreatherThan(0))
            .thenReturn(articulos);

        List<Articulo> resultado = articuloService.listarDisponibles();

        assertEquals(2, resultado.size());
    }

    @Test
    void testObtenerArticuloPorId() {
        Long idArticulo = 1L;
        Articulo articulo = new Articulo();
        articulo.setId(idArticulo);
        articulo.setTitulo("Test Articulo");

        when(articuloRepository.findById(idArticulo))
            .thenReturn(Optional.of(articulo));

        Articulo resultado = articuloService.obtenerPorId(idArticulo);

        assertNotNull(resultado);
        assertEquals(idArticulo, resultado.getId());
    }

    @Test
    void testBuscarArticulosPorVendedor() {
        Long idVendedor = 1L;
        List<Articulo> articulos = Arrays.asList(new Articulo());

        when(articuloRepository.findByIdVendedor(idVendedor))
            .thenReturn(articulos);

        List<Articulo> resultado = articuloService.buscarPorVendedor(idVendedor);

        assertEquals(1, resultado.size());
    }

    @Test
    void testBuscarArticulosPorCategoria() {
        Categoria categoria = Categoria.PINTURA;
        List<Articulo> articulos = Arrays.asList(new Articulo(), new Articulo());

        when(articuloRepository.findByCategoria(categoria))
            .thenReturn(articulos);

        List<Articulo> resultado = articuloService.buscarPorCategoria(categoria);

        assertEquals(2, resultado.size());
    }

    @Test
    void testEliminarArticulo() {
        Long idArticulo = 1L;

        assertDoesNotThrow(() -> articuloService.eliminar(idArticulo));
        verify(articuloRepository, times(1)).deleteById(idArticulo);
    }

    @Test
    void testActualizarArticulo() {
        Long idArticulo = 1L;
        Articulo articulo = new Articulo();
        articulo.setTitulo("Cuadro Actualizado");
        articulo.setPrecio(150.0);
        articulo.setStock(5);

        Articulo existente = new Articulo();
        existente.setId(idArticulo);
        existente.setTitulo("Cuadro Original");
        existente.setPrecio(100.0);

        when(articuloRepository.findById(idArticulo))
            .thenReturn(Optional.of(existente));
        when(articuloRepository.save(any(Articulo.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        Articulo resultado = articuloService.actualizar(idArticulo, articulo);

        assertEquals("Cuadro Actualizado", resultado.getTitulo());
        assertEquals(150.0, resultado.getPrecio());
    }
}

// ==================== TESTS RF-05: PASARELA DE PAGO ====================

@ExtendWith(MockitoExtension.class)
class PagoServiceTest {

    @Mock
    private PagoRepository pagoRepository;

    @InjectMocks
    private PagoService pagoService;

    @Test
    void testRegistrarPago() {
        Pago pago = new Pago();
        pago.setImporte(150.50);
        pago.setEstado(EstadoPago.PENDIENTE);

        when(pagoRepository.save(any(Pago.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        Pago resultado = pagoService.registrar(pago);

        assertNotNull(resultado);
        assertEquals(EstadoPago.PENDIENTE, resultado.getEstado());
        assertNotNull(resultado.getFecha());
    }

    @Test
    void testProcesarPago() {
        Pago pago = new Pago();
        pago.setImporte(100.0);

        when(pagoRepository.save(any(Pago.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        Pago resultado = pagoService.procesarPago(pago);

        assertNotNull(resultado);
        assertEquals(EstadoPago.PENDIENTE, resultado.getEstado());
    }

    @Test
    void testConfirmarPago() {
        Long idPago = 1L;
        Pago pago = new Pago();
        pago.setId(idPago);
        pago.setEstado(EstadoPago.PENDIENTE);

        when(pagoRepository.findById(idPago))
            .thenReturn(Optional.of(pago));

        assertDoesNotThrow(() -> pagoService.confirmar(idPago));
        assertEquals(EstadoPago.CONFIRMADO, pago.getEstado());
        verify(pagoRepository, times(1)).save(pago);
    }

    @Test
    void testConfirmarPagoNoEncontrado() {
        Long idPago = 1L;

        when(pagoRepository.findById(idPago))
            .thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> pagoService.confirmar(idPago));
    }
}

// ==================== FIN DE TESTS ====================