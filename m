Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D906446FE
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 Jun 2019 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392731AbfFMQz6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 Jun 2019 12:55:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34857 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729979AbfFMBuv (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 12 Jun 2019 21:50:51 -0400
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 45PRXS6nmmz9s4Y;
        Thu, 13 Jun 2019 11:50:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1560390648;
        bh=thn7JK5x3vGEaDygWLKfCJNwPqA7NrPpKmiNsfCzBiA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eey7gZAU+iIVNwJT6r3Z2OwFCrVtTtPJxvmwWdI0kssjTx8Fa6VZ/kEvJc7/oGENe
         YgJj8ZveeFQlj3df++v9w+nrDeEf6njTUIIr78NYWM21fgcdvrLBA9gkeFzoWlFBFw
         gRONCqAJwp+lNEp64bplPdrVPyb3uy5FsCvDXhv6rnYLdeBgZy1LYPuI1K0Awos0Uu
         nYmTRTq0CjGycSCS+qPseNTBNzTkCLP6rinjEu1KLUwILluX4bvVxQa7BtSr+y9hAG
         hzGn7c86sriq8R8i84uwzjTk21X76H0T/R6rfkY58NzviOI5v4qc2KAY4gxJm42ABk
         PVe30qPSGHmpg==
Received: by neuling.org (Postfix, from userid 1000)
        id DF3A62A0E2F; Thu, 13 Jun 2019 11:50:48 +1000 (AEST)
Message-ID: <688dfb940de8259630f249391c6cfd6e41c3bdee.camel@neuling.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix r3 corruption in h_set_dabr()
From:   Michael Neuling <mikey@neuling.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Suraj Jitindar Singh <surajjs@au1.ibm.com>
Date:   Thu, 13 Jun 2019 11:50:48 +1000
In-Reply-To: <1560386385.1924.2.camel@gmail.com>
References: <20190612072229.15832-1-mikey@neuling.org>
         <c648ec86-8af6-c61f-b430-8e4f7f19225d@kaod.org>
         <605bc6844ebb0ce2bf9dea906b707359500ceb4f.camel@neuling.org>
         <1560386385.1924.2.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


> > > 3:
> > >         /* Emulate H_SET_DABR/X on P8 for the sake of compat mode
> > > guests */
> > >         rlwimi  r5, r4, 5, DAWRX_DR | DAWRX_DW
> > > c00000000010b03c:       74 2e 85 50     rlwimi  r5,r4,5,25,26
> > >         rlwimi  r5, r4, 2, DAWRX_WT
> > > c00000000010b040:       f6 16 85 50     rlwimi  r5,r4,2,27,27
> > >         clrrdi  r4, r4, 3
> > > c00000000010b044:       24 07 84 78     rldicr  r4,r4,0,60
> > >         std     r4, VCPU_DAWR(r3)
> > > c00000000010b048:       c0 13 83 f8     std     r4,5056(r3)
> > >         std     r5, VCPU_DAWRX(r3)
> > > c00000000010b04c:       c8 13 a3 f8     std     r5,5064(r3)
> > >         mtspr   SPRN_DAWR, r4
> > > c00000000010b050:       a6 2b 94 7c     mtspr   180,r4
> > >         mtspr   SPRN_DAWRX, r5
> > > c00000000010b054:       a6 2b bc 7c     mtspr   188,r5
> > >         li      r3, 0
> > > c00000000010b058:       00 00 60 38     li      r3,0
> > >         blr
> > > c00000000010b05c:       20 00 80 4e     blr
> >=20
> > It's the `mtspr   SPRN_DAWR, r4` as you're HV=3D0.  I'm not sure how
> > nested works
> > in that regard. Is the level above suppose to trap and emulate
> > that? =20
> >=20
>=20
> Yeah so as a nested hypervisor we need to avoid that call to mtspr
> SPRN_DAWR since it's HV privileged and we run with HV =3D 0.
>=20
> The fix will be to check kvmhv_on_pseries() before doing the write. In
> fact we should avoid the write any time we call the function from _not_
> real mode.
>=20
> I'll submit a fix for the KVM side. Doesn't look like this is anything
> to do with Mikey's patch, was always broken as far as I can tell.

Thanks Suraj.

Mikey

