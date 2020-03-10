Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60838180C48
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Mar 2020 00:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCJXYi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 10 Mar 2020 19:24:38 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52947 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgCJXYi (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 10 Mar 2020 19:24:38 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48cWCJ6NCXz9sQt; Wed, 11 Mar 2020 10:15:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1583882108;
        bh=LU+M/j1oFo4YOaesD6PB/F2sxcmAD0EZ1H7Ku/nYSKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pB/s3JpulXmmgkjcelkuqzbC6v+wGqaCNc8D+GXgrKo86NM5ExD4XxAQH440yuLt6
         p9wwYJR333kOjdUU58fNtBefRp6vIr4eymIyh0jfqQgWch//LOzh4eTWetYHuTpSs/
         gpp8vbCuKvwiVK1zZk+rtGiI/vjRdglA3+DlJPII=
Date:   Wed, 11 Mar 2020 10:05:57 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Michael Roth <mdroth@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix H_CEDE return code for nested
 guests
Message-ID: <20200310230557.GP660117@umbus.fritz.box>
References: <20200310211128.17672-1-mdroth@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FbmEh7Ek6NM6xKh/"
Content-Disposition: inline
In-Reply-To: <20200310211128.17672-1-mdroth@linux.vnet.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--FbmEh7Ek6NM6xKh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2020 at 04:11:28PM -0500, Michael Roth wrote:
> The h_cede_tm kvm-unit-test currently fails when run inside an L1 guest
> via the guest/nested hypervisor.
>=20
>   ./run-tests.sh -v
>   ...
>   TESTNAME=3Dh_cede_tm TIMEOUT=3D90s ACCEL=3D ./powerpc/run powerpc/tm.el=
f -smp 2,threads=3D2 -machine cap-htm=3Don -append "h_cede_tm"
>   FAIL h_cede_tm (2 tests, 1 unexpected failures)
>=20
> While the test relates to transactional memory instructions, the actual
> failure is due to the return code of the H_CEDE hypercall, which is
> reported as 224 instead of 0. This happens even when no TM instructions
> are issued.
>=20
> 224 is the value placed in r3 to execute a hypercall for H_CEDE, and r3
> is where the caller expects the return code to be placed upon return.
>=20
> In the case of guest running under a nested hypervisor, issuing H_CEDE
> causes a return from H_ENTER_NESTED. In this case H_CEDE is
> specially-handled immediately rather than later in
> kvmppc_pseries_do_hcall() as with most other hcalls, but we forget to
> set the return code for the caller, hence why kvm-unit-test sees the
> 224 return code and reports an error.
>=20
> Guest kernels generally don't check the return value of H_CEDE, so
> that likely explains why this hasn't caused issues outside of
> kvm-unit-tests so far.
>=20
> Fix this by setting r3 to 0 after we finish processing the H_CEDE.
>=20
> RHBZ: 1778556
>=20
> Fixes: 4bad77799fed ("KVM: PPC: Book3S HV: Handle hypercalls correctly wh=
en nested")
> Cc: linuxppc-dev@ozlabs.org
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Michael Roth <mdroth@linux.vnet.ibm.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2cefd071b848..c0c43a733830 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3616,6 +3616,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64=
 time_limit,
>  		if (trap =3D=3D BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
>  		    kvmppc_get_gpr(vcpu, 3) =3D=3D H_CEDE) {
>  			kvmppc_nested_cede(vcpu);
> +			kvmppc_set_gpr(vcpu, 3, 0);
>  			trap =3D 0;
>  		}
>  	} else {

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--FbmEh7Ek6NM6xKh/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl5oHVIACgkQbDjKyiDZ
s5JwMA//eU73d+waNd47ydy7VR5a4Ch1jj0NvhreVqCm/BGmojxQ5HAhKhdegq2P
v9DUTT3fVyrp+HjH6tvUO+pGA0N7YtsX5/QBspYMQIoY5jypDyXmgh525aZDKlir
r5Qypc9tc0DrhJATJE4oeBaYfsnQMWzTlS3AgmVCuRCh2/QnHwagDt/2HQDwORk0
eHqx0uf5PV/vuFOTAXuLnfdua6O5/8TEE1lc3mBLQnkBNEuIdPPYiKd8+fFH5D0g
YMp8YhJ0DF/lq93uqKUo53UK8sCHk+vFyQvopSJ4cRGmQeEN66vo6y7sD5q+9NKu
U+K/i4aWhX9owLEBZ7BAAWmhmn3QJobKl5kPuRcxJVK+QTJytZnzOFpV2imfZu6e
5xldw9EabJrSQWwijWyoz7+fCIUGodwgDd9+yB87VzZj8uhef0G5h71PuVZFkChp
X/oaeZBjLG7Bvh5zudXc51prXndhSaNpyEzwm1QWQWwSs04+rd5wVrrRPM7xDfor
y/qCy9CLwnUhkTK0+UmLyWA/9MPB4icuFIqMedbOedBwFjRHDMp5TNUqGcsaC18g
AM7Z5FVjBSKAgjDIoRSs1Ri/nMC1VGTR2/qmeQWUifxBpsJyvC+jJ1lwUqqrGeRp
fqv05mHLQDv2j3c9vdYySEVNHiq+U1w6ko45yUSXuoh55GoP80o=
=VrOw
-----END PGP SIGNATURE-----

--FbmEh7Ek6NM6xKh/--
