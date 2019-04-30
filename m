Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F14F3CC
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Apr 2019 12:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfD3KL4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Apr 2019 06:11:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35841 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfD3KL4 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:56 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky1Vfzz9sCJ; Tue, 30 Apr 2019 20:11:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=PslQHeRzFmwzPRvTs98Q9t7OUv18yUrJfT4WStbCpxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBMnCfL+HOp1oo5VI6fRRSfB8J/MZcAa+7Zr90wipMgXwJSOTHOt3T8oQX8W5hOp1
         cWxm798CsE6jD/CLwBcPvBeGct0gbnTNFiDSGumUYNObaSZ5hkwQULwaoqzypDG5J4
         CDG8sUJgZmOxlAuzYElV109yVhxmUYp+f8dxpYCD1VZaH3TSq2R7AdM/s3S0AiDeoc
         ZzgbBdz7LT1TqswgNuRX5diMrKqdMvJ9HppBnIi4FWwbRcvYtb5SibnDtt+okaCptI
         i9w3CvNjxnhq3R3do8iOKZpcMUOVUpfdviMgHMZCMq5mxlleCuZXq+Q9VIl1unu45c
         WVhywtoxyTfTA==
Date:   Tue, 30 Apr 2019 20:02:31 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel] KVM: PPC: Avoid lockdep debugging in TCE realmode
 handlers
Message-ID: <20190430100231.GD32205@blackberry>
References: <20190329054220.48093-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329054220.48093-1-aik@ozlabs.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 29, 2019 at 04:42:20PM +1100, Alexey Kardashevskiy wrote:
> The kvmppc_tce_to_ua() helper is called from real and virtual modes
> and it works fine as long as CONFIG_DEBUG_LOCKDEP is not enabled.
> However if the lockdep debugging is on, the lockdep will most likely break
> in kvm_memslots() because of srcu_dereference_check() so we need to use
> PPC-own kvm_memslots_raw() which uses realmode safe
> rcu_dereference_raw_notrace().
> 
> This creates a realmode copy of kvmppc_tce_to_ua() which replaces
> kvm_memslots() with kvm_memslots_raw().
> 
> Since kvmppc_rm_tce_to_ua() becomes static and can only be used inside
> HV KVM, this moves it earlier under CONFIG_KVM_BOOK3S_HV_POSSIBLE.
> 
> This moves truly virtual-mode kvmppc_tce_to_ua() to where it belongs and
> drops the prmap parameter which was never used in the virtual mode.
> 
> Fixes: d3695aa4f452 ("KVM: PPC: Add support for multiple-TCE hcalls", 2016-02-15)
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks, patch applied to my kvm-ppc-next tree.

Paul.
