Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B031E347E
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 03:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgE0BNa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 May 2020 21:13:30 -0400
Received: from ozlabs.org ([203.11.71.1]:46385 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgE0BNa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 26 May 2020 21:13:30 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49WtBJ2Wtrz9sSc; Wed, 27 May 2020 11:13:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590542008; bh=oddGijCvExLxTfctJGGD9faXPFlbhlo4btxKmUAaMow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hE+HTJKZuQThboNSOyOWBAMAbuRtHu/qjydVkBKv5fwsvg7H33Z41hsFgLn705RR2
         p5iC6HJKAsGc4YRrVHXrkU57BEUiLMPSb+zyFtOr6Jx8zMG6yMYK+tQfi8l2QB94Iy
         efb+d6hLwlDZ0NDfuDmn/Tv0+jDgwMdkthW4oqUcHj8csSOQVmFn9iAL44LjRBMl9A
         9qcwOsNSib1t24NzuhOqXcMfchtYRmDr6lyZS/5MZ+tsQr0MfBdorH38Z4sTSCbpMT
         bsdQfqhKwizsDYOMjZsaKIq8YxTQF6902dA9AV/odVIfNtORjw+DwUMDiubOP6ZLqT
         bgJus6Q/e4pZg==
Date:   Wed, 27 May 2020 11:13:23 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Qian Cai <cai@lca.pw>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, aik@ozlabs.ru,
        paulmck@kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/kvm/book3s64/vio: fix some RCU-list locks
Message-ID: <20200527011323.GA293451@thinks.paulus.ozlabs.org>
References: <20200510051834.2011-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510051834.2011-1-cai@lca.pw>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, May 10, 2020 at 01:18:34AM -0400, Qian Cai wrote:
> It is unsafe to traverse kvm->arch.spapr_tce_tables and
> stt->iommu_tables without the RCU read lock held. Also, add
> cond_resched_rcu() in places with the RCU read lock held that could take
> a while to finish.

This mostly looks fine.  The cond_resched_rcu() in kvmppc_tce_validate
doesn't seem necessary (the list would rarely have more than a few
dozen entries) and could be a performance problem given that TCE
validation is a hot-path.

Are you OK with me modifying the patch to take out that
cond_resched_rcu(), or is there some reason why it's essential that it
be there?

Paul.
