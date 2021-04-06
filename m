Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5D6354BC3
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Apr 2021 06:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbhDFEhf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Apr 2021 00:37:35 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242441AbhDFEhe (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 6 Apr 2021 00:37:34 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4FDvrk4nhlz9sWQ; Tue,  6 Apr 2021 14:37:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617683846; bh=VZuzCILOIRol37URhiobWfkupK9ny+NNPs7jOctkUWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E6H8JPGeVXPRjLNkwWre49EODd8kqB8Y1GbQLw8uoJubll2G0oKHugO6gjR420zuZ
         A8lFrrhfVlaBTW17mjapYpSucVuRgUzQAjIlSNr5+/aniZDfZ1rV+emkzVmkvgMqgs
         cwBVUKbJj42ewMvfEscpRhRi6ZyhE8rGuptvXD83VTtZgkMHTkG15f7r2PuMf/Bezt
         r2sYZec50+KkIwdCAjfvZ0UTC3fEgnfSM7kWndzzPedy0I0BLHchmBirANX2xkFfvE
         P2C0NoRyqgx0wd6KctnL8f03bFQ4wtu5fv6gPPykZxf7F547aVos3vol0Hb+Uvir1p
         cdENlc3Ky/hCQ==
Date:   Tue, 6 Apr 2021 14:37:22 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 16/48] KVM: PPC: Book3S 64: Move interrupt early
 register setup to KVM
Message-ID: <YGvlguoc6IjjwybE@thinks.paulus.ozlabs.org>
References: <20210405011948.675354-1-npiggin@gmail.com>
 <20210405011948.675354-17-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405011948.675354-17-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Apr 05, 2021 at 11:19:16AM +1000, Nicholas Piggin wrote:
> Like the earlier patch for hcalls, KVM interrupt entry requires a
> different calling convention than the Linux interrupt handlers
> set up. Move the code that converts from one to the other into KVM.

I don't see where you do anything to enable the new KVM entry code to
access the PACA_EXSLB area when handling DSegI and ISegI interrupts.
Have I missed something, or are you not testing PR KVM at all?

Paul.
