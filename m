Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0117F110E
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfKFIaH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 03:30:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730092AbfKFIaG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 6 Nov 2019 03:30:06 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA68N8Ak127106
        for <kvm-ppc@vger.kernel.org>; Wed, 6 Nov 2019 03:30:05 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w3b2fb7vj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 06 Nov 2019 03:30:03 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 6 Nov 2019 08:29:53 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 6 Nov 2019 08:29:50 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA68Tn9x20185118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 08:29:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4322142042;
        Wed,  6 Nov 2019 08:29:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F84042041;
        Wed,  6 Nov 2019 08:29:47 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.101])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 Nov 2019 08:29:47 +0000 (GMT)
Date:   Wed, 6 Nov 2019 13:59:45 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 3/8] KVM: PPC: Shared pages support for secure guests
Reply-To: bharata@linux.ibm.com
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-4-bharata@linux.ibm.com>
 <20191106045238.GD12069@oak.ozlabs.ibm.com>
 <20191106082235.GC21634@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106082235.GC21634@in.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19110608-0012-0000-0000-00000361255F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110608-0013-0000-0000-0000219C8145
Message-Id: <20191106082945.GD21634@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=774 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911060088
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Nov 06, 2019 at 01:52:39PM +0530, Bharata B Rao wrote:
> > However, since kvmppc_gfn_is_uvmem_pfn() returned true, doesn't that
> > mean that pfn here should be a device pfn, and in fact should be the
> > same as uvmem_pfn (possibly with some extra bit(s) set)?
> 
> If secure page is being converted to share, pfn will be uvmem_pfn (device pfn).

Also, kvmppc_gfn_is_uvmem_pfn() needn't always return true. It returns
true only for secure pages, while this routine handles sharing of both
secure and normal pages.

Regards,
Bharata.

