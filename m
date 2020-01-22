Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FA5144C15
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jan 2020 07:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVGyu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jan 2020 01:54:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgAVGyt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jan 2020 01:54:49 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00M6lXvC058173
        for <kvm-ppc@vger.kernel.org>; Wed, 22 Jan 2020 01:54:49 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xp3u6r0gv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 22 Jan 2020 01:54:49 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Wed, 22 Jan 2020 06:54:43 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Jan 2020 06:54:40 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00M6scVq42991928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 06:54:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2BB2A4051;
        Wed, 22 Jan 2020 06:54:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18F56A4059;
        Wed, 22 Jan 2020 06:54:38 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.124.31.197])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 22 Jan 2020 06:54:37 +0000 (GMT)
Subject: Re: [PATCH FIX] KVM: PPC: Book3S HV: Release lock on page-out failure
 path
To:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Cc:     paulus@au1.ibm.com
References: <20200122045542.3527-1-bharata@linux.ibm.com>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date:   Wed, 22 Jan 2020 12:24:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122045542.3527-1-bharata@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20012206-0016-0000-0000-000002DF9519
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012206-0017-0000-0000-000033423F23
Message-Id: <8211e2c3-7e40-a4df-0b67-cb45ca3f108b@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=492 lowpriorityscore=0 mlxscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220061
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 1/22/20 10:25 AM, Bharata B Rao wrote:
> When migrate_vma_setup() fails in kvmppc_svm_page_out(),
> release kvm->arch.uvmem_lock before returning.
> 
> Fixes: ca9f4942670 ("KVM: PPC: Book3S HV: Support for running secure guests")
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Kamalesh

