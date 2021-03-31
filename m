Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4FF34F831
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhCaE65 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:58:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46179 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCaE6n (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 00:58:43 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9Dc15vyQz9sWX; Wed, 31 Mar 2021 15:58:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617166721; bh=1Jp2PVYuBwxl9vR5J6ojXLJS2rIfGO+/7iEhzEz4i1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vSoQ47XO0dYsl0+qzBNZxQdkJD6eb8YSctBF9MF5c5z8E0O65eE2BpsvvntgrZDca
         1aPkpWlPW2BJsfnkzQo8Da44xc0yq0BG1mMZpw4i4SCWq7bUEAO+cT3QrR3yQ9SYqE
         1bC7TOqqPjxMjEyjqI/OlV+ELiQXxdNrPOlz9uA1QFEUg7mwC3432daWIddv473Stg
         PwOkLH4zGfPPmVfu7uDG8yKCPR48ybjYGJHz27HQHy1718HBb9BsUyLHQnEHGXKj1R
         DMCjv/ukgdYSBZz4GnplBj7/ncF/unU9L2KOgftl6diMmItBDWmDpIXq9oxB7ry8sw
         GTo7EfSqmw7Yg==
Date:   Wed, 31 Mar 2021 15:58:29 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 11/46] KVM: PPC: Book3S HV: Ensure MSR[HV] is always
 clear in guest MSR
Message-ID: <YGQBdVntWnG/ewtj@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-12-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-12-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:30AM +1000, Nicholas Piggin wrote:
> Rather than clear the HV bit from the MSR at guest entry, make it clear
> that the hypervisor does not allow the guest to set the bit.
> 
> The HV clear is kept in guest entry for now, but a future patch will
> warn if it's not present.

Will warn if it *is* present, surely?

> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
