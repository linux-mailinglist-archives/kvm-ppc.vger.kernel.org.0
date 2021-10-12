Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2511429B4C
	for <lists+kvm-ppc@lfdr.de>; Tue, 12 Oct 2021 04:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhJLCLB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Oct 2021 22:11:01 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:51287 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhJLCLB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 11 Oct 2021 22:11:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HSzcB30wCz4xbc;
        Tue, 12 Oct 2021 13:08:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634004538;
        bh=hzcHFArt94zy363Gzhk7t10ot1lGPm8IAL6s4wImyCc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JOVVwsUfORu9PY7ma0fPedRzQxhk7QXd0AJrZ0JblugIjzl2isW6Y21f8YJ94OgVe
         plHnW8dcsdZOwQhajUHBotDHm/EtfgOT94xWFVu3vqTvpl6xjgUmBZQT7iyyYknFT1
         XaymkcVsdHgoALaIW/0efoF5xxRIDW2XqDm1mfm0TYAMd4nEGAijnK7wzkXFfc6mF5
         pBNylazJAscSKJjkCl+d59LkhoU5ckjAi5Z8nt8vZJX1/bBFlIjA+ioJoIz7jgCF4Q
         PGi//H0HsQwQpDPZuUVUjfH9yfrGeBnCysoyhkQeKso6wWfyt/M+zwLNW3gnAgBIAJ
         +PnmIrCuR6zBg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 02/52] powerpc/64s: guard optional TIDR SPR with CPU
 ftr test
In-Reply-To: <87v9235rl2.fsf@linux.ibm.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
 <20211004160049.1338837-3-npiggin@gmail.com>
 <87v9235rl2.fsf@linux.ibm.com>
Date:   Tue, 12 Oct 2021 13:08:57 +1100
Message-ID: <87k0ijm1ty.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fabiano Rosas <farosas@linux.ibm.com> writes:
> Nicholas Piggin <npiggin@gmail.com> writes:
>
>> The TIDR SPR only exists on POWER9. Avoid accessing it when the
>> feature bit for it is not set.
>
> Not related to this patch, but how does this work with compat mode? A P9
> compat mode guest would get an invalid instruction when trying to access
> this SPR?

Good question.

I assume you're talking about P9 compat mode on P10.

In general compat mode only applies to userspace, because it's
implemented by setting the PCR which only (mostly?) applies to PR=3D1.

I don't think there's any special casing in the ISA for the TIDR, so I
think it just falls into the unimplemented SPR case for mt/fspr.

That's documented in Book III section 5.4.4, in particular on page 1171
it says:

  Execution of this instruction specifying an SPR number
  that is undefined for the implementation causes one of
  the following.
  =E2=80=A2 if spr[0]=3D0:
    - if MSR[PR]=3D1: Hypervisor Emulation Assistance interrupt
    - if MSR[PR]=3D0: Hypervisor Emulation Assistance interrupt for SPR
      0,4,5, and 6, and no operation (i.e., the instruction is treated
      as a no-op) when LPCR[EVIRT]=3D0 and Hypervisor Emulation Assistance
      interrupt when LPCR[EVIRT]=3D1 for all other SPRs

Linux doesn't set EVIRT, and I assume neither does phyp, so it behaves
like a nop.

We actually use that behaviour in xmon to detect that an SPR is not
implemented, by noticing that the mfspr has no effect on the target
register, see dump_one_spr().

We should really write some docs on compat mode in the linuxppc wiki
and/or Documentation ;)

cheers
