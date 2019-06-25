Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D529F521CF
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jun 2019 06:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfFYELJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jun 2019 00:11:09 -0400
Received: from ozlabs.org ([203.11.71.1]:37085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbfFYELJ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 25 Jun 2019 00:11:09 -0400
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 45Xt4p1ZWLz9sCJ;
        Tue, 25 Jun 2019 14:11:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1561435866;
        bh=z0/ihHpiOuXsbcpJCDJR+F4nPEv0A8fBy1dW1ce5JiI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O/oi0O9LPR58IUljvbxMGkFpcxaf89ElJlcjefVtskrH35b6figdHO0wK4F3w79j/
         KgulxYc+Ovc/8/SormuKqOpXzsfdbkAyVJtzDOMqdm50gCxYxobrOe91kdynUCZXD0
         EPG6eLCxFWvdDFMx6og8l260r2DdG9mE3RNayOyQQ6isCRcUnS4hfY7teQuKzMZfxp
         UzgLdbW+5fU4AC8cO6FwMEbk44WhwrjLwBeyqdT40hgmKuCr+iSJvIABroDJQxktN7
         8ZtZLM5IpCav7scQYp1/Va7PsgtyrhcOkcmrLnsN3aaS9MFQ66PII9M5AK2lGp73nR
         tQUzC7XHa5BPQ==
Received: by neuling.org (Postfix, from userid 1000)
        id 0BD232A257E; Tue, 25 Jun 2019 14:11:06 +1000 (AEST)
Message-ID: <d30b3450fadab64705067cda56ddee5e06d60448.camel@neuling.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation
From:   Michael Neuling <mikey@neuling.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        kvm-ppc@vger.kernel.org, sjitindarsingh@gmail.com
Date:   Tue, 25 Jun 2019 14:11:05 +1000
In-Reply-To: <87tvcf8arn.fsf@concordia.ellerman.id.au>
References: <20190620060040.26945-1-mikey@neuling.org>
         <87tvcf8arn.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 2019-06-24 at 21:48 +1000, Michael Ellerman wrote:
> Michael Neuling <mikey@neuling.org> writes:
> > When emulating tsr, treclaim and trechkpt, we incorrectly set CR0. The
> > code currently sets:
> >     CR0 <- 00 || MSR[TS]
> > but according to the ISA it should be:
> >     CR0 <-  0 || MSR[TS] || 0
>=20
> Seems bad, what's the worst case impact?

It's a data integrity issue as CR0 is corrupted.

> Do we have a test case for this?

Suraj has a KVM unit test for it.

> > This fixes the bit shift to put the bits in the correct location.
>=20
> Fixes: ?

It's been around since we first wrote the code so:

Fixes: 4bb3c7a0208fc13c ("KVM: PPC: Book3S HV: Work around transactional me=
mory bugs in POWER9")

Mikey
