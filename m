Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3C3FF9F0
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 Sep 2021 07:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhICFPC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 3 Sep 2021 01:15:02 -0400
Received: from ozlabs.org ([203.11.71.1]:51111 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232717AbhICFPB (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 3 Sep 2021 01:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1630646041;
        bh=6ILjOh+kIuiDJYXTi/RPyp3NIhH+Al2Jv7RlEtYBSbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pi4gUp4YG5ns5iot1nsYqUDbV7rdNGQN64aFAaUQ4zj2UZy/qE6vLSeCzpD+dO3la
         johT1E8S3d1Eb/BNp4RoeyiRqNwqv4tBOgVeumJEn7hcRN2M3s9oefAxl+mKzNGb/9
         qQcQCzBv38lVHRkYb4qWjgXkZZXt1IX1Mca2fhcY=
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4H15Yj1MXRz9sW4; Fri,  3 Sep 2021 15:14:01 +1000 (AEST)
Date:   Fri, 3 Sep 2021 15:13:55 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: Re: [PATCH 0/5] KVM: PPC: Book3S: Modules cleanup and unification
Message-ID: <YTGvE9o9e0qCz9xA@yekko>
References: <20210901173357.3183658-1-farosas@linux.ibm.com>
 <YTAownlTy46X4jGV@yekko>
 <875yvjujxy.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZzHFj0RmvuubG6he"
Content-Disposition: inline
In-Reply-To: <875yvjujxy.fsf@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--ZzHFj0RmvuubG6he
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 02, 2021 at 11:32:41AM -0300, Fabiano Rosas wrote:
> David Gibson <david@gibson.dropbear.id.au> writes:
>=20
> > On Wed, Sep 01, 2021 at 02:33:52PM -0300, Fabiano Rosas wrote:
> >> This series merges our three kvm modules kvm.ko, kvm-hv.ko and
> >> kvm-pr.ko into one kvm.ko module.
> >
> > That doesn't sound like a good idea to me.  People who aren't on BookS
> > servers don't want - and can't use - kvm-hv.  Almost nobody wants
> > kvm-pr.  It's also kind of inconsistent with x86, which has the
> > separate AMD and Intel modules.
>=20
> But this is not altering the ability of having only kvm-hv or only
> kvm-pr. I'm taking the Kconfig options that used to produce separate
> modules and using them to select which code gets built into the one
> kvm.ko module.

>=20
> Currently:
>=20
> CONFIG_KVM_BOOK3S_64=3Dm     <-- produces kvm.ko
> CONFIG_KVM_BOOK3S_64_HV=3Dm  <-- produces kvm-hv.ko
> CONFIG_KVM_BOOK3S_64_PR=3Dm  <-- produces kvm-pr.ko
>=20
> I'm making it so we now have one kvm.ko everywhere, but there is still:
>=20
> CONFIG_KVM_BOOK3S_64=3Dm           <-- produces kvm.ko
> CONFIG_KVM_BOOK3S_HV_POSSIBLE=3Dy  <-- includes HV in kvm.ko
> CONFIG_KVM_BOOK3S_PR_POSSIBLE=3Dy  <-- includes PR in kvm.ko
>=20
> In other words, if you are going to have at least two modules loaded at
> all times (kvm + kvm-hv or kvm + kvm-pr), why not put all that into one
> module? No one needs to build code they are not going to use, this is
> not changing.

Ah.. I see, you're removing the runtime switch from one to the other
at the same time as having just a single one loaded, but leaving the
ability to compile time switch.  And compile time is arguably good
enough for the cases I've described.

Ok, I see your point.

I still think it's conceptually not ideal, but the practical benefit
is more important.  Objection withdrawn.


> About consistency with x86, this situation is not analogous because we
> need to be able to load both modules at the same time, which means
> kvm.ko needs to stick around when one module goes away in case we want
> to load the other module. The KVM common code states that it expects to
> have at most one implementation:
>=20
>         /*
>          * kvm_arch_init makes sure there's at most one caller
>          * for architectures that support multiple implementations,
>          * like intel and amd on x86.
>          (...)
>=20
> which is not true in our case due to this requirement of having two
> separate modules loading independently.
>=20
> (tangent) We are already quite different from other architectures since
> we're not making use of kvm_arch_init and some other KVM hooks, such as
> kvm_arch_check_processor_compat. So while other archs have their init
> dispatched by kvm common code, our init and cleanup happens
> independently in the ppc-specific modules, which obviously works but is
> needlessly different and has subtleties in the ordering of operations
> wrt. the kvm common code. (tangent)
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ZzHFj0RmvuubG6he
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmExrxMACgkQbDjKyiDZ
s5KohA/9Gfq6pHibFuBWjrN/3iQF/0n0TzlL6x1jWavUn8C6eW+QySpkHDQ1CMV0
27NLIaan0NNq7H4TDxeI4QnVlJOQUXxeTKmtbi8F3fdTceF61M4frRMtH5sMS5fC
0g+t5vzD4Hd1cz8d/fuVVGWiR8HI+L6+ft+V2F7qQA1ruHcG1TPhMFKg+iZidfnL
JEfQHgyQseyYxux96pMumgXHWnX5N5jvvcjMKl22PWQaQRGuavt+iqNeeUTFFrCD
q7VTBsJwvmaXZ255MrbMT7DDtNMFEy/PbV5tWbM7Lb6Y5IQvDeK+kwUsZKi1cYph
U8RzVueTpF2yeK58ZyypXNB8EgMK6SiSycy/Wc1eyiPE4MCFmw0eVgjW4AdUtZpv
4/H8u4+izQOBOLZZ1MoXU36Tdap8v1ApPnFiMTRycIrbEBKJURzjakrI+IDerJF5
6fvfTP1/60PUhdNkjSBDa6SoLi3AKAhetiNcIwAoo4jhIykwoRe+QLTg+ZAzQi2X
SXAKwMKlF8AacTfilP5qiZ0P00UO7fDyDwHXJ5IrPeHNwb+38MbA33d+K9eOgqCv
LtNw6HuGK7G9Z6RPWEB0hrhEPVjeqw3XPLxxkXesEHOnnA+nBMC/gcoiEGCkTF2s
Hw7nJGIsPDYug//XJxY9LQkIV82qkkM9t407sEEoQC2Q+XEstpQ=
=hJiE
-----END PGP SIGNATURE-----

--ZzHFj0RmvuubG6he--
