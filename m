Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3520831497F
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 08:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhBIH1Z (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 02:27:25 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:45375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhBIH1J (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 9 Feb 2021 02:27:09 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4DZZFZ2XFpz9sVb; Tue,  9 Feb 2021 18:26:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1612855586; bh=eAF06QftqYsZL7ivOiu83OsCP4EL0rXb6vvmYHo2HrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZepJz4VvzaYEGNPVfAhvykvjeKTSTGwD84ThIbAjtI8ORe9x1mLhVyD9vj/nHeFF5
         TPznt88gMG4BiYUAs8JwBZ/2oqwMPAjMLtNP+T3lunfdgImmN3RcWW6t+b16+49tr0
         ry8fWJoj69AdA1pME+4F57wFNxpI3DfeX6zHcysnp5lbyzp2/yzozoPeCa8HGyL9qj
         KCBz6r8EEB3+vPbUsnP9U6wBckM7SIaoCfahWamYF9ITZk0/tfwkPeophaeL2UyzSn
         EFFjLhZWP309Jc0al0SFHm96Qd6tSmqSRZrACOZr8zqqiBFpo2NvnnObB+SUDFr8ek
         bHLUW1a85Hxpg==
Date:   Tue, 9 Feb 2021 18:23:55 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a
 vcpu moves between threads in a core
Message-ID: <20210209072355.GB2841126@thinks.paulus.ozlabs.org>
References: <20210118122609.1447366-1-npiggin@gmail.com>
 <20210118122609.1447366-2-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118122609.1447366-2-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jan 18, 2021 at 10:26:09PM +1000, Nicholas Piggin wrote:
> As explained in the comment, there is no need to flush TLBs on all
> threads in a core when a vcpu moves between threads in the same core.
> 
> Thread migrations can be a significant proportion of vcpu migrations,
> so this can help reduce the TLB flushing and IPI traffic.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> I believe we can do this and have the TLB coherency correct as per
> the architecture, but would appreciate someone else verifying my
> thinking.

So far I have not been able to convince myself that migrating within a
core is really different from migrating across cores as far as the
architecture is concerned.  If you're trying to allow for an
implementation where TLB entries are shared but tlbiel only works
(effectively and completely) on the local thread, then I don't think
you can do this.  If a TLB entry is created on T0, then the vcpu moves
to T1 and does a tlbiel, then the guest task on that vcpu migrates to
the vcpu that is on T2, it might still see a stale TLB entry.

Paul.
