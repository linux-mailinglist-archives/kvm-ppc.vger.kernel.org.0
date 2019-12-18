Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D27123F2D
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Dec 2019 06:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfLRFgh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Dec 2019 00:36:37 -0500
Received: from ozlabs.org ([203.11.71.1]:36267 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfLRFgh (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 18 Dec 2019 00:36:37 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47d3fC0xHGz9sS9; Wed, 18 Dec 2019 16:36:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1576647395; bh=arBhEw9NZmuhyzR9ri9+gjUXrFXvq5epgRZxiP5ucNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NhDElDY9zmVJkVePcXc133bDxJpq78JWTKjRkTXTN6bvZxBcOMs/hpys48N9ukgp5
         7nr87BGLpPTjupTI3yUT9v/j+7oL4tN9jKYRu6RkJmW/tKHKcDW1YYaHFcfDBJ0RTs
         DibDDbf0taAlwZgPKYksGt895RCWB/0WCHTEGK6d4quXaHvrclxZt2LnGZsI25Ey/F
         G2m0THpYmB1CcvqPc2Bo2kI0b9cFWAonDWr7INs1X+72+hxT97NUjLcpbAlCQHdol8
         mCEqVeLIlhnEieHqyFkljrQlMYO+C6I2s9mKYosevnS/8uLY6sIDh5mlbdEHavlrAA
         H6IEgkuH1/f/A==
Date:   Wed, 18 Dec 2019 16:32:50 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, linuxram@us.ibm.com,
        Bharata B Rao <bharata@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V3 1/2] KVM: PPC: Add skip_page_out parameter
Message-ID: <20191218053250.GB29890@oak.ozlabs.ibm.com>
References: <20191215021104.GA27378@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215021104.GA27378@us.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Dec 14, 2019 at 06:11:04PM -0800, Sukadev Bhattiprolu wrote:
> 
> This patch is based on Bharata's v11 KVM patches for secure guests:
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-November/200918.html
> ---
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 13 Dec 2019 15:06:16 -0600
> Subject: [PATCH V3 1/2] KVM: PPC: Add skip_page_out parameter
> 
> Add 'skip_page_out' parameter to kvmppc_uvmem_drop_pages() which will
> be needed in a follow-on patch that implements H_SVM_INIT_ABORT hcall.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Paul Mackerras <paulus@ozlabs.org>
