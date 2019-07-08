Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF5618C1
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 03:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfGHBTo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 7 Jul 2019 21:19:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57703 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfGHBTo (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 7 Jul 2019 21:19:44 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45hng26v5bz9sP6; Mon,  8 Jul 2019 11:19:42 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 3fefd1cd95df04da67c83c1cb93b663f04b3324f
In-Reply-To: <20190620060040.26945-1-mikey@neuling.org>
To:     Michael Neuling <mikey@neuling.org>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     mikey@neuling.org, linuxppc-dev@lists.ozlabs.org,
        sjitindarsingh@gmail.com, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation
Message-Id: <45hng26v5bz9sP6@ozlabs.org>
Date:   Mon,  8 Jul 2019 11:19:42 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-06-20 at 06:00:40 UTC, Michael Neuling wrote:
> When emulating tsr, treclaim and trechkpt, we incorrectly set CR0. The
> code currently sets:
>     CR0 <- 00 || MSR[TS]
> but according to the ISA it should be:
>     CR0 <-  0 || MSR[TS] || 0
> 
> This fixes the bit shift to put the bits in the correct location.
> 
> Tested-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/3fefd1cd95df04da67c83c1cb93b663f04b3324f

cheers
