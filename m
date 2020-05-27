Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200D71E370C
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 06:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgE0EVN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 May 2020 00:21:13 -0400
Received: from ozlabs.org ([203.11.71.1]:46085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgE0EVD (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 27 May 2020 00:21:03 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49WyLj0Yf1z9sPF; Wed, 27 May 2020 14:21:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590553261; bh=eCU8X9wRDZzbEoypesdQISc5J/H8gswzhje60culhhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NvjFzCgoGwZfWfZdWhowsFPcEgbAthogqz43Wu55JJek+CecgA1Vm1V0OyMsEhwGg
         k5nfMcfDV1cr/Jmias9LVJGbLcBNwdX9ZzEIuPp5CEiYbxj5B3AsCb+Zn5Cl9rvHQn
         uMYjYkkrMzGQEyjHsnf62EZl9xNQxr+kdUW9B2gq6ufLlBJv8frN3XRCBb5OU43KuA
         MW18mCF3nStwTN5fhg/CtZbxa/yrCRAc7FfeyCepzs7O2gft4INYZ7HY+VnKfUHZdY
         dCMm83AVzDA2vXCaCkSo4a2yra4j7f75PeuBZLfmmwYYcImvBu0zmZsnpnGE0BpDC9
         skr0LlwvVdzWA==
Date:   Wed, 27 May 2020 14:15:30 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     benh@kernel.crashing.org, mpe@ellerman.id.au,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] KVM: PPC: Book3S HV: remove redundant NULL check
Message-ID: <20200527041530.GB293451@thinks.paulus.ozlabs.org>
References: <20200401130903.6576-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401130903.6576-1-chenzhou10@huawei.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Apr 01, 2020 at 09:09:03PM +0800, Chen Zhou wrote:
> Free function kfree() already does NULL check, so the additional
> check is unnecessary, just remove it.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Thanks, applied to my kvm-ppc-next branch.

Paul.
