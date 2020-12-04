Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375692CEDA6
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Dec 2020 13:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgLDMA0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 4 Dec 2020 07:00:26 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:50975 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgLDMA0 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 4 Dec 2020 07:00:26 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CnWTs3gD5z9sWn; Fri,  4 Dec 2020 22:59:45 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Mahesh Salgaonkar <mahesh@linux.ibm.com>
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
Subject: Re: [PATCH 0/8] powerpc/64s: fix and improve machine check handling
Message-Id: <160708314571.99163.1566766431664408141.b4-ty@ellerman.id.au>
Date:   Fri,  4 Dec 2020 22:59:45 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 28 Nov 2020 17:07:20 +1000, Nicholas Piggin wrote:
> First patch is a nasty memory scribble introduced by me :( That
> should go into fixes.
> 
> The next ones could wait for next merge window. They get things to the
> point where misbehaving or buggy guest isn't so painful for the host,
> and also get the guest SLB dumping code working (because the host no
> longer clears them before delivering the MCE to the guest).
> 
> [...]

Patch 1 applied to powerpc/fixes.

[1/8] powerpc/64s/powernv: Fix memory corruption when saving SLB entries on MCE
      https://git.kernel.org/powerpc/c/a1ee28117077c3bf24e5ab6324c835eaab629c45

cheers
