Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B9B123E3C
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Dec 2019 05:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLREFP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Dec 2019 23:05:15 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:48529 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfLREFN (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 17 Dec 2019 23:05:13 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47d1cm0Fsvz9sSP; Wed, 18 Dec 2019 15:05:11 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 228b607d8ea1b7d4561945058d5692709099d432
In-Reply-To: <20191215094900.46740-1-marcus@mc.pp.se>
To:     "Marcus Comstedt" <marcus@mc.pp.se>, kvm-ppc@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Marcus Comstedt <marcus@mc.pp.se>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix regression on big endian hosts
Message-Id: <47d1cm0Fsvz9sSP@ozlabs.org>
Date:   Wed, 18 Dec 2019 15:05:11 +1100 (AEDT)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, 2019-12-15 at 09:49:00 UTC, "Marcus Comstedt" wrote:
> VCPU_CR is the offset of arch.regs.ccr in kvm_vcpu.
> arch/powerpc/include/asm/kvm_host.h defines arch.regs as a struct
> pt_regs, and arch/powerpc/include/asm/ptrace.h defines the ccr field
> of pt_regs as "unsigned long ccr".  Since unsigned long is 64 bits, a
> 64-bit load needs to be used to load it, unless an endianness specific
> correction offset is added to access the desired subpart.  In this
> case there is no reason to _not_ use a 64 bit load though.
> 
> Signed-off-by: Marcus Comstedt <marcus@mc.pp.se>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/228b607d8ea1b7d4561945058d5692709099d432

cheers
