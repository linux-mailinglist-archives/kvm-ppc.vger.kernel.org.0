Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DDE233E5A
	for <lists+kvm-ppc@lfdr.de>; Fri, 31 Jul 2020 06:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgGaEeh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 31 Jul 2020 00:34:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17368 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbgGaEeh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 31 Jul 2020 00:34:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V4WkZL112544;
        Fri, 31 Jul 2020 00:34:22 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32krgeqtjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 00:34:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V4TwSI018729;
        Fri, 31 Jul 2020 04:33:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 32gcpx6ukc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 04:33:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V4XdJZ12124530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 04:33:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D1A842047;
        Fri, 31 Jul 2020 04:33:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0825F42042;
        Fri, 31 Jul 2020 04:33:37 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.52.65])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jul 2020 04:33:36 +0000 (GMT)
Date:   Fri, 31 Jul 2020 10:03:34 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>, sukadev@linux.ibm.com,
        corbet@lwn.net, linux-doc@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        ldufour@linux.ibm.com, david@gibson.dropbear.id.au,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Define H_PAGE_IN_NONSHARED for
 H_SVM_PAGE_IN hcall
Message-ID: <20200731043334.GB20199@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <alpine.DEB.2.22.394.2007301231140.2548@hadrien>
 <20200730232101.GB5882@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730232101.GB5882@oc0525413822.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_01:2020-07-30,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 mlxlogscore=905 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=1 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310031
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 30, 2020 at 04:21:01PM -0700, Ram Pai wrote:
> H_SVM_PAGE_IN hcall takes a flag parameter. This parameter specifies the
> way in which a page will be treated.  H_PAGE_IN_NONSHARED indicates
> that the page will be shared with the Secure VM, and H_PAGE_IN_SHARED
> indicates that the page will not be shared but its contents will
> be copied.

Looks like you got the definitions of shared and non-shared interchanged.

> 
> However H_PAGE_IN_NONSHARED is not defined in the header file, though
> it is defined and documented in the API captured in
> Documentation/powerpc/ultravisor.rst
> 
> Define H_PAGE_IN_NONSHARED in the header file.

What is the use of defining this? Is this used directly in any place?
Or, are youp planning to introduce such a usage?

Regards,
Bharata.
