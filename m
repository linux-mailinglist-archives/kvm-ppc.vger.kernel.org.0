Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F97138925
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 Jan 2020 02:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgAMBJY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 12 Jan 2020 20:09:24 -0500
Received: from ozlabs.org ([203.11.71.1]:40941 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgAMBJY (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 12 Jan 2020 20:09:24 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47wwTt1qsQz9sP3; Mon, 13 Jan 2020 12:09:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1578877762; bh=leii6v6Dj/RGlbG1OQ5MHtdg57WwGh/HerboWbNo31w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzVxd3D47/6AlSFNN18mP1fF7j3C2FvNmqK++vMCc11szGYsp9hUzPoieaE4nV8YS
         wdAuWkO4ieSjY7J+H5XwsITPyk9QGZou5x6G2p/SddUCiVZyHsGeNTiA9VX3bC6/kp
         7/tv2YdHkRdjaj5e6v0fHqcKMeog/sEE0AHImJgCxMuOBOgsgwt7Vm4qMQ6H3KR/f9
         ZmxBF5bINAuh+Kn1JRNJBI4EOwbBqBRrrbI7BdeDNX9wfl0Dg3R7ZugvR/BW5UbygK
         dDwxSTMEx6DCl/fwNGzzR+PlUiLzV3am0wSvZZftmFsM29BSx8ppy0V/dDAwphu+u7
         CyScF/c54n0sg==
Date:   Mon, 13 Jan 2020 08:48:22 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, linuxram@us.ibm.com,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v3 2/2] powerpc/pseries/svm: Disable BHRB/EBB/PMU access
Message-ID: <20200112214822.GA3536@blackberry>
References: <20200110051957.31714-1-sukadev@linux.ibm.com>
 <20200110051957.31714-2-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110051957.31714-2-sukadev@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jan 09, 2020 at 09:19:57PM -0800, Sukadev Bhattiprolu wrote:
> Ultravisor disables some CPU features like BHRB, EBB and PMU in
> secure virtual machines (SVMs). Skip accessing those registers
> in SVMs to avoid getting a Program Interrupt.

It would be useful to have more explanation of the rationale for the
ultravisor disabling access to those features, and indicate whether
this is a temporary restriction or a permanent one.  If SVMs are never
going to be able to use the PMU then that is a bad thing in my
opinion.  In other words, the commit message should tell us whether
the restriction is just because the ultravisor doesn't yet have code
for managing and context-switching the PMU, or if there is there some
reason why using the PMU in a SVM will always be prohibited for some
security-related reason.

Also, the only way that a SVM would be getting into the KVM code that
you are patching is if it is trying to do nested virtualization.
However, the SVM should already know that it is not able to do nested
virtualization because the ultravisor should be intercepting and
failing the H_SET_PARTITION_TABLE hypercall.  So I think there is no
good reason for patching the KVM code like you are doing unless the
PMU restriction is permanent and we are intending someday to enable
SVMs to have nested guests.

Paul.
